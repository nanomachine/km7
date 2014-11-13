class SessionsController < ApplicationController
  #skip_before_filter :require_login

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      #Verify if the user wants the system to remember his/her credentials
      if params[:remember_me]
        sign_in_remember user
      else
        sign_in user
      end
        redirect_to dashboard_path
    else
      flash.now[:error] = 'Username or password is incorrect. Please, try again.'
      redirect_to root_path
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
	
end
