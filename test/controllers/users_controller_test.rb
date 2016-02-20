require 'test_helper'

class Api::UsersControllerTest < ActionController::TestCase
  test "create with new user" do
    post :create, {user: {user_name: 'Bob'}}
    assert_response :created
  end

  test "create with existing user" do
    post :create, {user: {user_name: 'Al'}}
    assert_response :unprocessable_entity
  end
end
