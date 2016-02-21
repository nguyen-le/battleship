require 'test_helper'

class Api::GamesControllerTest < ActionController::TestCase
  test "create new game" do
    post :create, {game:{owner_id: users(:one).id, opponent_id: users(:two).id}}
    assert_response :created
  end

  test "create fails without opponent" do
    post :create, {game:{owner_id: users(:one).id}}
    assert_response :unprocessable_entity
  end
end
