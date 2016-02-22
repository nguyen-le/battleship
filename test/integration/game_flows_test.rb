require 'test_helper'

class GameFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @owner = users(:one)
    @opp = users(:two)
  end

  # translate to controller actions
  # TODO how to work with sessions
  test '2 players on api firing until one wins' do
  end

  # test '2 players alternate firing until one wins' do
  #   game_service = GameService.factory(@game)
  #   game_service.enter_setup_phase
  #   game_service.build_ship(@owner, Ship::DESTROYER, ['a1', 'a2'])
  #   game_service.build_ship(@owner, Ship::CRUISER, ['b1', 'b2', 'b3'])
  #   game_service.build_ship(@owner, Ship::SUBMARINE, ['c1', 'c2', 'c3'])
  #   game_service.build_ship(@owner, Ship::BATTLESHIP, ['d1', 'd2', 'd3', 'd4'])
  #   game_service.build_ship(@owner, Ship::CARRIER, ['e1', 'e2', 'e3', 'e4', 'e5'])
  #   game_service.build_ship(@opp, Ship::DESTROYER, ['a1', 'a2'])
  #   game_service.build_ship(@opp, Ship::CRUISER, ['b1', 'b2', 'b3'])
  #   game_service.build_ship(@opp, Ship::SUBMARINE, ['c1', 'c2', 'c3'])
  #   game_service.build_ship(@opp, Ship::BATTLESHIP, ['d1', 'd2', 'd3', 'd4'])
  #   game_service.build_ship(@opp, Ship::CARRIER, ['e1', 'e2', 'e3', 'e4', 'e5'])
  #   @game.save

  #   game_service.enter_firing_phase
  #   attacker = @game.current_attacker_id == @owner.id ? @owner : @opp
  #   defender = (attacker == @owner) ? @opp : @owner
  #   cols = ('a'..'e').to_a

  #   counter = 0
  #   i = 1
  #   letter_idx = 0
  #   letter = cols[letter_idx]
  #   until @game.status == Game::FINISHED
  #     location = letter + i.to_s
  #     shot = game_service.build_shot(attacker, location)

  #     game_service.process_player_dmg(shot)

  #     attacker, defender = defender, attacker
  #     counter += 1

  #     if counter.even?
  #       i += 1
  #       if i == 6
  #         i = 1
  #         letter_idx += 1
  #         letter = cols[letter_idx]
  #       end
  #     end
  #   end
  #   assert @game.status == Game::FINISHED
  # end
end
