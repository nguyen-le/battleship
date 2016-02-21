require 'test_helper'

class Api::UsersControllerTest < ActionController::TestCase
  # Index
  test "index returns up to 100 items" do
    User.create(user_name: 'Al')
    resp = get :index
    fetched_users = JSON.parse(resp.body).fetch('users')

    assert_response :ok
    assert fetched_users.length <= 100
  end

  test "index query by user_name returns array with user if found" do
    name = 'Alton'
    resp = get :index, user_name: name
    fetched_users = JSON.parse(resp.body).fetch('users')

    assert_response :ok
    assert fetched_users[0]['user_name'] == name
  end

  test "index query by user_name returns empty array if not found" do
    name = 'Bill'
    resp = get :index, user_name: name
    fetched_users = JSON.parse(resp.body).fetch('users')

    assert_response :ok
    assert fetched_users == []
  end


  # Create
  test "create with new user" do
    post :create, {user: {user_name: 'Bob'}}
    assert_response :created
  end

  test "create with existing user" do
    post :create, {user: {user_name: 'Alton'}}
    assert_response :unprocessable_entity
  end


  # Show
  test "show with existing user id" do
    user = users(:one)
    resp = get :show, id: user.id

    fetched_user = JSON.parse(resp.body).fetch('user')

    assert_response :ok, 'not ok'
    assert fetched_user['user_name'] == user.user_name
  end

  test "show with non-existent user id" do
    resp = get :show, id: 0
    error_msg = JSON.parse(resp.body).fetch('errors')

    assert_response :not_found
    assert error_msg
  end
end
