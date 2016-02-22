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
  def _get_game_boundaries
    a_z = ('a'..'z').to_a
    case @game.game_type
    when Game::SMALL
      {alphabet: a_z[0..6], number: 6}
    when Game::STANDARD
      {alphabet: a_z[0..10], number: 10}
    when Game::LARGE
      {alphabet: a_z[0..20], number: 20}
    end
  end

  def _parse_location_arr_to_map(location_arr)
    location_map = {}
    boundaries = _get_game_boundaries

    starting_column = nil
    starting_row = nil

    same_column = true
    same_row = true

    location_arr.each do |square|
      row_letter = square.downcase.match(/[a-z]+/).to_s
      starting_column ||= row_letter
      same_column = false if starting_column != row_letter

      row_num = square.match(/\d+/).to_s.to_i
      starting_row ||= row_num
      same_row = false if starting_row != row_letter

      if !(row_letter.length == 1 &&
          boundaries[:alphabet].include?(row_letter) &&
          row_num.between?(1, boundaries[:number]) &&
          (same_column || same_row))
        raise 'Invalid ship location'
      end
      location_map[square] = 1
    end
    return location_map
  end
end
