require 'test_helper'

class PlayerStateTest < ActiveSupport::TestCase
  setup do
    @owner = users(:one)
    @opp = users(:two)
    @game = Game.create(owner: @owner, opponent: @opp)
  end

  test 'build player state' do
    assert true
  end
end
