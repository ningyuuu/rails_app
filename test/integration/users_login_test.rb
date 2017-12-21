require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
  end

  test "invalid login only flashes one error" do
    get login_path
    assert_template "sessions/new"
    assert flash.empty?

    post login_path, params: { session: {
      email: 'invalid@email.add',
      password: 'neverthispassword'
    }}
    assert_template "sessions/new"
    assert_not flash.empty?, 'flash appears'

    get root_path
    assert flash.empty?, 'flash disappears upon redirect'
  end

  test "can log in with valid information then log out" do
    get login_path
    post login_path, params: { session: {
      email: @user.email,
      password: 'password'
    }}

    assert_redirected_to @user
    follow_redirect!

    assert_template 'users/show'

    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!

    # simulate clicking log out in another window
    delete logout_path
    follow_redirect!

    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember: '1')
    assert_not_empty cookies['remember_token']
  end

  test "login without remembering" do
    # Log in to set the cookie.
    log_in_as(@user, remember: '1')
    # Log in again and verify that the cookie is deleted.
    log_in_as(@user, remember: '0')
    assert_empty cookies['remember_token']
  end
end
