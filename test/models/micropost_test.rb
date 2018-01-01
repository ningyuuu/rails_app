require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup 
    @user = users(:michael)
    @micropost = @user.microposts.build(content: "Lorem Ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "no user_id = not valid" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should not be blank" do
    @micropost.content = "      "
    assert_not @micropost.valid?
  end

  test "content should not be >140 chars" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
