module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def curr_user
    if session[:user_id]
      @curr_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @curr_user = user
      end
    end
  end

  def logged_in?
    !curr_user.nil?
  end

  def log_out
    forget @curr_user
    session.delete :user_id
    @curr_user = nil
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
