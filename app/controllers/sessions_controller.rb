class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # render the user's page
      params[:session][:remember] == '1' ? remember(user) : forget(user)
      log_in user
      redirect_back_or user
    else
      # render some errors
      flash.now[:danger] = 'Invalid username/password combination entered.'
      render 'new'
    end 
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end 
end
