require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { 
      user: { 
        name: "",
        email: "foo@invalid",
        password: "foo",
        password_confirmation: "bar"
      }
    }

    assert_template 'users/edit'
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    
    patch user_path(@user), params: {
      user: {
        name: "Example",
        email: "example@email.com",
        password: "",
        password_confirmation: ""
      }
    }

    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal "Example", @user.name
    assert_equal "example@email.com", @user.email
  end

  test "should redirect from edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect from update when not logged in" do
    patch user_path(@user), params: { 
      user: { 
        name: @user.name,
        email: @user.email 
      }
    }
    assert_not flash.empty?
    assert_redirected_to login_path
  end

end
