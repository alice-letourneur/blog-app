require 'test_helper'

class CreateUsersTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(username: "Test", email: "test@test.test", password: "password")
  end

  test "get sign up form and create new user" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post users_path, params:{user: {username: "alice", email: "alice@alice.alice", password: "password"}}
      follow_redirect!
    end
    assert_template 'users/show'
    assert_match "alice", response.body
  end

  test "invalid user creation due to missing info results in failure" do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post users_path, params:{user: {username: "", email: "alice@alice.alice", password: "password"}}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
    assert_match "blank", response.body
    assert_no_difference 'User.count' do
      post users_path, params:{user: {username: "alice", email: "", password: "password"}}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
    assert_match "blank", response.body
    assert_no_difference 'User.count' do
      post users_path, params:{user: {username: "alice", email: "alice@alice.alice", password: ""}}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
    assert_match "blank", response.body
  end

  test "invalid user creation due to duplicate user results in failure" do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post users_path, params:{user: {username: "Test", email: "alice@test.test", password: "password"}}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
    assert_match "Username has already been taken", response.body
    assert_no_difference 'User.count' do
      post users_path, params:{user: {username: "NewTest", email: "test@test.test", password: "password"}}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
    assert_match "Email has already been taken", response.body
  end
end
