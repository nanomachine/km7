class UsersController < ApplicationController
  
  
  #Make sure user is signed in and is admin to create other users (this feature is off
    #while on development phase)

  #before_filter :signed_in_user, only: [:index, :edit, :update, :destroy ]

  #before_filter :correct_user, only: [:edit, :update]

  #before_filter :admin_user,  only: [:destroy]


	def show
		@user = User.find(params[:id])
	end
	
  def new
  	@user = User.new
	end

  def index
    @users = User.paginate(page: params[:page])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to Km7!"
      redirect_to @user
    else
      flash[:error] = 'Incomplete information, user not created'
      redirect_to users_path
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      redirect_to @user
    end
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to @user
    else
      redirect_to @user
    end
  end


=begin
  private

  #This method should work but for some reason .required does not run for HashWithIndifferentAccess
  #This could present a problem for logging from the mobile app

  def user_params
    params.required(:user).permit(:password, :password_confirmation)
  end


  private

    def signed_in_user
      unless user_signed_in?
        store_location
        redirect_to new_user_path, notice: "Please sign up."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user? (@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
=end
end
