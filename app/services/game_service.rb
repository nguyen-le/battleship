class GameService
  def self.factory(game)
    game_policy = GamePolicy.new(game)
    GameService.new(game, game_policy)
  end

  def initialize(game, game_policy)
    @game = game
    @game_policy = game_policy
  end

  def build_player_state(user)
    health, grid =
      case @game.game_type
      when Game::SMALL
        [Game::SMALL_HP, Game.create_grid(Game::SMALL)]
      when Game::STANDARD
        [Game::STANDARD_HP, Game.create_grid(Game::STANDARD)]
      when Game::LARGE
        [Game::LARGE_HP, Game.create_grid(Game::LARGE)]
      end

    @game.player_states.build(user: user, health: health, grid: grid)
  end

  def build_ship(user, ship_type, location_arr)
    raise 'Cant create Ship at this time' unless @game_policy.is_setup_phase?
    raise 'Cant create anymore Ships' unless @game_policy.can_create_more_ships?(user)
    raise 'Invalid ship size' unless Ship.get_size(ship_type) == location_arr.length

    location_map = _parse_location_arr_to_map(location_arr)

    @game.ships.build(user: user, ship_type: ship_type, location: location_map)
  end

  def build_shot(user, location)
    receiving_player = @game.owner_id == user.id ? @game.opponent : @game.owner

    raise 'Invalid shot location' unless @game_policy.location_within_bounds?(location)

    shot = @game.shots.build(user: user, receiving_player: receiving_player, location: location)
    if shot.valid?
      shot
    else
      raise 'Duplicate shot'
    end
  end

  def process_player_dmg(shot)
    user = shot.receiving_player
    ship =
      @game.ships.where(user_id: user.id)
        .where('location ? :square', square: shot.location)
        .first

    new_value_for_grid = 1
    player_state = user.player_states.where(game_id: @game.id).first
    column = player_state.grid.fetch(shot.location.match(/[a-z]{1}/i).to_s)
    if ship
      ship_hp = ship.location.fetch(shot.location)
      ship.location[shot.location] = ship_hp - 1
      new_value_for_grid = 2
      player_state.health -= 1

      if player_state.health == 0
        enter_game_finished_phase(shot.user)
      end
    end
    column[shot.location.match(/\d+/).to_s.to_i] = new_value_for_grid

    ActiveRecord::Base.transaction do
      @game.save
      ship.save
      shot.save
      user.save
      player_state.save
    end
    return user
  end

  def process_surrender(user)
    winning_player = (@game.owner_id == user.id) ?
      @game.opponent :
      @game.owner
    player_state = user.player_states.where(game_id: @game.id).first
    player_state.health = 0
    @game.winning_player_id = winning_player.id
    @game.status = Game::FINISHED

    @game.transaction do
      player_state.save!
      @game.save!
    end
  end

  def enter_setup_phase
    update_status(Game::SETUP)
    randomize_starting_player
    build_player_state(@game.owner)
    build_player_state(@game.opponent)
  end

  def enter_firing_phase
    @game.status = Game::IN_PROGRESS if @game_policy.can_start_game?
  end

  def enter_game_finished_phase(winning_player)
    @game.winning_player_id = winning_player.id
    @game.status = Game::FINISHED
  end

  def randomize_starting_player
    @game.current_attacker_id = [@game.owner_id, @game.opponent_id].sample
  end

  def update_status(status)
    @game.status = status
  end

  private
  def _parse_location_arr_to_map(location_arr)
    location_map = {}

    starting_column = nil
    starting_row = nil

    same_column = true
    same_row = true

    location_arr.each do |square|
      row_letter, letter_within_bounds = @game_policy.letter_col_within_bounds(square)
      starting_column ||= row_letter
      same_column = false if starting_column != row_letter

      row_num, num_within_bounds = @game_policy.num_row_within_bounds(square)
      starting_row ||= row_num
      same_row = false if starting_row != row_letter

      if !(row_letter.length == 1 &&
          letter_within_bounds &&
          num_within_bounds &&
          (same_column || same_row))
        raise 'Invalid ship location'
      end
      location_map[square] = 1
    end
    return location_map
  end
end
