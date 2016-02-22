require 'test_helper'

class GameServiceTest < ActionController::TestCase
  setup do
    @owner = users(:one)
    @opp = users(:two)
    @game = Game.create(owner: @owner, opponent: @opp)
  end

  test 'constructor' do
    game_service = GameService.new(@game)
    assert game_service.game == @game
  end

  test 'build ship' do
    game_service = GameService.new(@game)
    ship = game_service.build_ship(@owner, Ship::CRUISER)

  end

  test 'build player states' do
    game_service = GameService.new(@game)
    game_service.build_player_state(@owner)
    game_service.build_player_state(@opp)

    @game.player_states.each do |state|
      assert state.health == Game::STANDARD_HP
    end
  end

  test 'do setup phase' do
    game_service = GameService.new(@game)
    game_service.do_setup_phase

    assert @game.status == Game::SETUP
    @game.player_states.each do |state|
      assert state.health == Game::STANDARD_HP
    end
  end

  test 'randomize starting player' do
    game_service = GameService.new(@game)
    assert @game.current_attacker_id.nil?

    game_service.randomize_starting_player
    assert_not @game.current_attacker_id.nil?
  end

  test 'update status' do
    new_status = Game::FINISHED

    game_service = GameService.new(@game)
    game_service.update_status(new_status)

    assert @game.status == new_status
  end
end
