require 'test_helper'

class Api::ShipsControllerTest < ActionController::TestCase
  setup do
    @owner = users(:one)
    @opp = users(:two)
    @game = Game.create(owner: @owner, opponent: @opp, status: Game::SETUP)
  end

  test "create - ship" do
    payload = {
      game_id: @game.id,
      ship: {
        ship_type: Ship::CRUISER,
        location: ['a1', 'a2', 'a3']
      }
    }

    post :create, payload, {user_id: @owner.id}

    assert_response :created
  end
end
