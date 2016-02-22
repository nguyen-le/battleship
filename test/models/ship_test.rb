require 'test_helper'

class ShipTest < ActiveSupport::TestCase
  setup do
    @owner = users(:one)
    @opp = users(:two)
    @game = Game.create(owner: @owner, opponent: @opp)
  end

  test 'cant have two of the same ships' do
    ship = Ship.new(
      user_id: @owner.id,
      game_id: @game.id,
      ship_type: Ship::CARRIER,
      location: {'a1' => 1}
    )
    ship_2 = Ship.new(
      user_id: @owner.id,
      game_id: @game.id,
      ship_type: Ship::CARRIER,
      location: {'b1' => 1}
    )
    assert ship.save
    assert_not ship_2.save
  end
end
