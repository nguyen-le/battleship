require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'state - new game has status pending' do
    owner = users(:one)
    opponent = users(:two)
    game = Game.create(owner: owner, opponent: opponent)
    assert game.status = Game::PENDING
  end

  test "valid - Game with both owner_id and opponent_id" do
    owner = users(:one)
    opponent = users(:two)
    game = Game.new(owner: owner, opponent: opponent)
    assert game.save
  end

  test "invalid - Game without both owner and opponent" do
    user = users(:one)
    game_a = Game.new
    game_b = Game.new(owner: user)
    game_c = Game.new(opponent: user)
    assert_not game_a.save
    assert_not game_b.save
    assert_not game_c.save
  end
end
