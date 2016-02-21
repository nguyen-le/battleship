class GameService
  attr_accessor :game

  def initialize(game)
    @game = game
  end

  def do_setup_phase
    update_status(Game::SETUP)
    randomize_starting_player

    # create playerstate
    # @game.player_state.build()
    # @game.player_state.build

  end

  def randomize_starting_player
    @game.current_attacker_id = [@game.owner_id, @game.opponent_id].sample
  end

  def update_status(status)
    @game.status = status
  end
end
