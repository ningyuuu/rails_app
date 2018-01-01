require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path

    # pagination of microposts
    assert_select 'div.pagination'
    assert_select 'input[type=file]'

    # invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: '' } } 
    end
    assert_select 'div#error_explanation'

    # valid submission
    content = "some micropost content here"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: {content: content, picture: picture}}
    end
    assert Micropost.first.picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body

    # delete post
    get root_path
    assert_select 'a', text: 'Delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    # can't delete other peoples posts
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
end
