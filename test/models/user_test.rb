require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "User has valid user_name" do
    user = User.new(user_name: 'Bob')
    assert user.valid?
  end

  test "User must have user_name" do
    user = User.new
    assert_not user.valid?
  end

  test "User must have unique user_name" do
    user = User.new(user_name: 'Al')
    assert_not user.valid?
  end
end
