class UsersController < ApplicationController
  
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :new, :create]

  before_filter :correct_user, only: [:edit, :update]

  before_filter :admin_user,  only: [:destroy, :new, :create]


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
      flash[:success] = "Bienvenido a Km7!"
      redirect_to @user
    else
      flash.now[:error] = 'Credenciales incorrectos'
      render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Usuario borrado"
    redirect_to users_path
  end

  def edit
  end

  def update
    if @user.update_attribueveloptes(params[:user])
      flash[:success] = "Perfil actualizado"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Favor de registrarse."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user? (@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
