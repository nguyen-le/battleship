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

    @game.shots.build(user: user, receiving_player: receiving_player, location: location)
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

  def randomize_starting_player
    @game.current_attacker_id = [@game.owner_id, @game.opponent_id].sample
  end

  def update_status(status)
    @game.status = status
  end

  private
  def _parse_location_arr_to_map(location_arr)
    location_map = {}
    boundaries = @game_policy.game_boundaries

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
