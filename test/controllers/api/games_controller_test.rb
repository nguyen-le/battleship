require 'test_helper'

class Api::GamesControllerTest < ActionController::TestCase
  setup do
    @owner = users(:one)
    @opp = users(:two)
    @game = Game.create(owner: @owner, opponent: @opp)
  end

  # Index
  test "index" do
    resp = get :index
    fetched_games = JSON.parse(resp.body).fetch('games')

    assert_response :ok
    assert fetched_games.length == 2, 'more than 1'
    #assert fetched_games.length == 1, 'more than 1'
  end


  # Create
  test "create new game" do
    post :create, {game: {opponent_id: @opp.id}}, {user_id: @owner.id}
    assert_response :created
  end

  test "create fails without opponent" do
    post :create, {game: {opponent_id: 0}}, {user_id: @owner.id}
    assert_response :unprocessable_entity
  end


  # Show
  test "show with existing user id" do
    resp = get :show, id: @game.id
    fetched_game = JSON.parse(resp.body).fetch('game')

    assert_response :ok, 'not ok'
    assert fetched_game['id'] == @game.id
    assert fetched_game['owner']['id'] == @game.owner_id
    assert fetched_game['opponent']['id'] == @game.opponent_id
  end

  test "show with non-existent user id" do
    resp = get :show, id: 0
    error_msg = JSON.parse(resp.body).fetch('errors')

    assert_response :not_found
    assert error_msg
  end


  # Accept
  test "accept - opponent can accept game challenge" do
    resp = post :accept, {id: @game.id}, {user_id: @opp.id}
    game = JSON.parse(resp.body).fetch('game')

    assert_response :ok
    assert game['status'] == 'setup'
  end

  test "accept - bad - only opponent can accept game challenge" do
    resp = post :accept, {id: @game.id}, {user_id: @owner.id}
    error_msg = JSON.parse(resp.body).fetch('errors')

    assert_response :unprocessable_entity
    assert error_msg
  end


  # Start
  test "start - game cant start until ships created" do
    resp = post :start, {id: @game.id}, {user_id: @owner.id}
    game = JSON.parse(resp.body).fetch('game')
    assert game.fetch('status') != Game::IN_PROGRESS
  end

  test "start - game can start" do
    game_service = GameService.factory(@game)
    game_service.enter_setup_phase
    game_service.build_ship(@owner, Ship::DESTROYER, ['a1', 'a2'])
    game_service.build_ship(@owner, Ship::CRUISER, ['b1', 'b2', 'b3'])
    game_service.build_ship(@owner, Ship::SUBMARINE, ['c1', 'c2', 'c3'])
    game_service.build_ship(@owner, Ship::BATTLESHIP, ['d1', 'd2', 'd3', 'd4'])
    game_service.build_ship(@owner, Ship::CARRIER, ['e1', 'e2', 'e3', 'e4', 'e5'])
    game_service.build_ship(@opp, Ship::DESTROYER, ['a1', 'a2'])
    game_service.build_ship(@opp, Ship::CRUISER, ['b1', 'b2', 'b3'])
    game_service.build_ship(@opp, Ship::SUBMARINE, ['c1', 'c2', 'c3'])
    game_service.build_ship(@opp, Ship::BATTLESHIP, ['d1', 'd2', 'd3', 'd4'])
    game_service.build_ship(@opp, Ship::CARRIER, ['e1', 'e2', 'e3', 'e4', 'e5'])
    @game.save
    resp = post :start, {id: @game.id}, {user_id: @owner.id}
    game = JSON.parse(resp.body).fetch('game')
    assert game.fetch('status') == Game::IN_PROGRESS
  end
end
