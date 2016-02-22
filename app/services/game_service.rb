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

  def build_ship(user, ship_type)
    @game.ships.build(user: user, ship_type: ship_type)
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
