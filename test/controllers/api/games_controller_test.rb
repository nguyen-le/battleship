require 'test_helper'

class Api::GamesControllerTest < ActionController::TestCase
  # Index
  test "index" do
    owner = users(:one)
    opp = users(:two)
    Game.create(owner: owner, opponent: opp)
    Game.create(owner: owner, opponent: opp)

    resp = get :index
    fetched_games = JSON.parse(resp.body).fetch('games')

    assert_response :ok
    assert fetched_games.length == 2
  end


  # Create
  test "create new game" do
    post :create, {game:{owner_id: users(:one).id, opponent_id: users(:two).id}}
    assert_response :created
  end

  test "create fails without opponent" do
    post :create, {game:{owner_id: users(:one).id}}
    assert_response :unprocessable_entity
  end


  # Show
  test "show with existing user id" do
    owner = users(:one)
    opp = users(:two)
    game = Game.create(owner: owner, opponent: opp)

    resp = get :show, id: game.id
    fetched_game = JSON.parse(resp.body).fetch('game')

    assert_response :ok, 'not ok'
    assert fetched_game['id'] == game.id
    assert fetched_game['owner']['id'] == game.owner_id
    assert fetched_game['opponent']['id'] == game.opponent_id
  end

  test "show with non-existent user id" do
    resp = get :show, id: 0
    error_msg = JSON.parse(resp.body).fetch('error')

    assert_response :not_found
    assert error_msg
  end
end
