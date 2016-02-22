class GameService
  attr_accessor :game

  def initialize(game)
    @game = game
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
    a_z = ('a'..'z').to_a
    boundaries =
      case @game.game_type
      when Game::SMALL
        {alphabet: a_z[0..6], number: 6}
      when Game::STANDARD
        {alphabet: a_z[0..10], number: 10}
      when Game::LARGE
        {alphabet: a_z[0..20], number: 20}
      end

    ship_size = Ship.get_size(ship_type)
    raise 'Invalid ship size' if ship_size != location_arr.length

    starting_column = nil
    starting_row = nil
    same_column = true
    same_row = true
    location_map = {}
    location_arr.each do |square|
      row_letter = square.downcase.match(/[a-z]+/).to_s
      starting_column ||= row_letter

      row_num = square.match(/\d+/).to_s.to_i
      starting_row ||= row_num
      if !(row_letter.length == 1 &&
          boundaries[:alphabet].include?(row_letter) &&
          row_num.between?(1, boundaries[:number]) &&
          (same_column || same_row))
        raise 'Invalid ship location'
      end
      location_map[square] = 1
    end

    @game.ships.build(user: user, ship_type: ship_type, location: location_map)
  end

  def do_setup_phase
    update_status(Game::SETUP)
    randomize_starting_player
    build_player_state(@game.owner)
    build_player_state(@game.opponent)
  end

  def randomize_starting_player
    @game.current_attacker_id = [@game.owner_id, @game.opponent_id].sample
  end

  def update_status(status)
    @game.status = status
  end
end
