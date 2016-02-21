class GameService
  attr_accessor :game

  def initialize(game)
    @game = game
  end

  def do_setup_phase
    update_status(Game::SETUP)
    randomize_starting_player

    health, grid =
      case @game.game_type
      when Game::SMALL
        [Game::SMALL_HP, Game.create_grid(Game::SMALL)]
      when Game::STANDARD
        [Game::STANDARD_HP, Game.create_grid(Game::STANDARD)]
      when Game::LARGE
        [Game::LARGE_HP, Game.create_grid(Game::LARGE)]
      end

    @game.player_states.build(user_id: @game.owner_id, health: health, grid: grid)
    @game.player_states.build(user_id: @game.opponent_id, health: health, grid: grid)
  end

  def randomize_starting_player
    @game.current_attacker_id = [@game.owner_id, @game.opponent_id].sample
  end

  def update_status(status)
    @game.status = status
  end
end
