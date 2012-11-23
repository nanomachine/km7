class ListsController < ApplicationController

def new
    @list = List.new
  end

#Show report details and only show selescted problem in gmap
  def show
    @list = List.find(params[:id])
  end

#Show list of reports and show all of them in gmap
  def index
    @lists = List.paginate(page: params[:page])
  end

  def create
    @list = List.new(params[:problem])
    #Para obtener el usuario actual que esta creando el reporte solo funciona
    #por webapp. Su motivo aplicar relación belongs_to de "problems"
    @list.user_id = current_user.id
    if @list.save
      flash[:success] = "Problema guardado"
      redirect_to @list
    else
      flash.now[:error] = 'Informacion incorrecta'
      render 'new'
    end
  end

  def destroy
    List.find(params[:id]).destroy*
    flash[:success] = "Problema borrado."
    redirect_to problems_url
  end

  def update
  end

end
