class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = curr_user.microposts.build
      @feed_items = curr_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
