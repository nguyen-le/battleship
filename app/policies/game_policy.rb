class GamePolicy
  def initialize(game)
    @game = game
  end

  def can_create_more_ships?(user)
    Ship.where(game_id: @game.id, user_id: user.id).count <= ships_allowed
  end

  def can_start_game?
    @game.status == Game::SETUP &&
      (Ship.where(game_id: @game.id, user_id: [@game.owner_id, @game.opponent_id]).count ==
        (ships_allowed * 2))
  end

  def ships_allowed
    case @game.game_type
    when Game::SMALL
      2
    when Game::STANDARD
      5
    when Game::LARGE
      10
    end
  end

  def is_setup_phase?
    @game.status == Game::SETUP
  end
end
