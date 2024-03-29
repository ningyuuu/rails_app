require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # create a new user, but not adding to db
  def setup
    @user = User.new(
      name: "Test User", 
      email: "user@email.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "blank names should not be valid" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "blank email should not be valid" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "name should be at most 50 characters" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should be at most 255 characters" do
    @user.email = "a" * 248 + "@abc.com"
    assert_not @user.valid?
  end

  test "email should be valid for common address" do
    valid_address = %w[
      user@example.com 
      USER@foo.COM
      A_US-er@foo.bar.org
      first.last@foo.jp
      alice+bob@baz.cn
    ]

    valid_address.each do |email|
      @user.email = email
      assert @user.valid?, "#{email.inspect} should be valid"
    end
  end

  test "email should reject invalid address" do
    invalid_addresses = %w[
      user@example,com
      user_at_foo.org
      user.name@example.
      foo@bar_baz.com
      foo@bar+baz.com
    ]

    invalid_addresses.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email.inspect} should not be valid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should not be blank" do
    @user.password = " " * 8
    @user.password_confirmation = @user.password
    assert_not @user.valid?
  end

  test "password should at least be 8 chars" do
    @user.password = "a" * 7
    @user.password_confirmation = @user.password
    assert_not @user.valid?
  end

  test "password should match confirmation" do
    @user.password_confirmation = "password1"
    assert_not @user.valid?
  end

  test "blank remember_digest should not throw an error" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "user can follow and unfollow another user" do
    michael = users(:michael)
    archer = users(:archer)
    assert_not michael.following?(archer)

    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followedby?(michael)

    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # Posts from self
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
end
