class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        sign_in_remember user
      else
        sign_in user
      end
        redirect_to a_dashboard_path
    else
      flash.now[:error] = 'Username or password is incorrect. Please, try again.'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
	
end
