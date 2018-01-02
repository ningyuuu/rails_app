class RelationshipsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  def create
    # param given is user's id as :followed_id
    user = User.find_by(id: params[:followed_id])
    curr_user.follow(user)
    redirect_to user
  end

  def destroy
    # param given is relationship
    user = Relationship.find(params[:id]).followed
    curr_user.unfollow(user)
    redirect_to user
  end
end
