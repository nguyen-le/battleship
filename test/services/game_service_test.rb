require 'test_helper'

class GameServiceTest < ActionController::TestCase
  setup do
    @owner = users(:one)
    @opp = users(:two)
    @game = Game.create(owner: @owner, opponent: @opp)
  end

  test 'build player states' do
    game_service = GameService.factory(@game)
    game_service.build_player_state(@owner)
    game_service.build_player_state(@opp)

    @game.player_states.each do |state|
      assert state.health == Game::STANDARD_HP
    end
  end

  test 'build ship' do
    @game.status = Game::SETUP
    game_service = GameService.factory(@game)
    ship = game_service.build_ship(@owner, Ship::CRUISER, ['a1', 'a2', 'a3'])
    ship.save

    assert ship.user = @owner
    assert ship.ship_type = Ship::CRUISER
    assert ship.location = {'a1' => 1, 'a2' => 1, 'a3' => 1}
    assert ship.health == 3
  end

  test 'build shot' do
    game_service = GameService.factory(@game)
    shot = game_service.build_shot(@owner, 'a1')

    assert shot.save
  end

  test 'enter setup phase' do
    game_service = GameService.factory(@game)
    game_service.enter_setup_phase

    assert @game.status == Game::SETUP
    @game.player_states.each do |state|
      assert state.health == Game::STANDARD_HP
    end
  end

  test 'enter firing phase' do
    game_service = GameService.factory(@game)
    @game.status = Game::SETUP
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

    game_service.enter_firing_phase
    assert @game.status == Game::IN_PROGRESS
  end

  test 'randomize starting player' do
    game_service = GameService.factory(@game)
    assert @game.current_attacker_id.nil?

    game_service.randomize_starting_player
    assert_not @game.current_attacker_id.nil?
  end

  test 'update status' do
    new_status = Game::FINISHED

    game_service = GameService.factory(@game)
    game_service.update_status(new_status)

    assert @game.status == new_status
  end

  test 'process player dmg' do
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

    game_service.enter_firing_phase
    attacker = @game.current_attacker_id == @owner.id ? @owner : @opp
    shot = game_service.build_shot(attacker, 'a1')

    user = game_service.process_player_dmg(shot)

    player_state = PlayerState.where(game_id: @game.id, user_id: user.id).first
    ship = Ship.where(game_id: @game.id, user_id: user.id)
      .where('location ? :sq', sq: shot.location).first
    assert @game.current_attacker_id = user.id
    assert player_state.health  == 16
    assert ship.location.fetch('a1') == 0
    assert ship.location.fetch('a2') == 1
  end

  test 'process surrender' do
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

    game_service.enter_firing_phase
    game_service.process_surrender(@opp)
    assert @game.status == Game::FINISHED
  end

  test '2 players alternate firing until one wins' do
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

    game_service.enter_firing_phase
    attacker = @game.current_attacker_id == @owner.id ? @owner : @opp
    defender = (attacker == @owner) ? @opp : @owner
    cols = ('a'..'e').to_a

    counter = 0
    i = 1
    letter_idx = 0
    letter = cols[letter_idx]
    until @game.status == Game::FINISHED
      location = letter + i.to_s
      shot = game_service.build_shot(attacker, location)

      game_service.process_player_dmg(shot)

      attacker, defender = defender, attacker
      counter += 1

      if counter.even?
        i += 1
        if i == 6
          i = 1
          letter_idx += 1
          letter = cols[letter_idx]
        end
      end
    end
    assert @game.status == Game::FINISHED
  end
end
