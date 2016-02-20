require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "Game created with owner_id and opponent_id" do
    owner = users(:one)
    opponent = users(:two)
    game = Game.new(owner: owner, opponent: opponent)
    assert game.save
  end

  test 'new game has status pending' do
    owner = users(:one)
    opponent = users(:two)
    game = Game.create(owner: owner, opponent: opponent)
    assert game.status = Game::PENDING
  end

  test "Game not created when not having an owner and opponent" do
    begin
      Game.create
    rescue ActiveRecord::ActiveRecordError => e
    end

    assert e
  end
end
