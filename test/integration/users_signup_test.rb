require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup should not increase user count" do
    get signup_path
    assert_no_difference 'User.count' do 
      post users_path, params: { user: {
        name: "",
        email: "invalid@email",
        password: "",
        password_confirmation: "asd"
      }}
    end
    assert_template 'users/new'
  end

  test "valid signup should increase user count by 1 and send mail" do 
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { 
        user: {
          name: 'hellotestuser',
          email: 'validemail@valid.com',
          password: "qwer1234",
          password_confirmation: "qwer1234"
        }
      }
    end
    follow_redirect!
    # assert_template 'users/show'
    # assert is_logged_in?
  end
end
