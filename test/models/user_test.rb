require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "User created with valid user_name" do
    user = User.new(user_name: 'Bob')
    assert user.save
  end

  test "User not created without user_name" do
    user = User.new
    assert_not user.save
  end

  test "User not created when having non-unique user_name" do
    user = User.new(user_name: 'Alton')
    assert_not user.save
  end
end
