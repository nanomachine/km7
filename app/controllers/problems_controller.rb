class ProblemsController < ApplicationController

  def new
    @problem = Problem.new
  end

  def show
    @problem = Problem.find(params[:id])
  end

  def index
    @problems = Problem.paginate(page: params[:page])
  end

  def create
    @problem = Problem.new(params[:problem])
    if @problem.save
      flash[:success] = "Problema guardado"
      redirect_to @problem
    else
      flash.now[:error] = 'Informacion incorrecta'
      render 'new'
    end
  end

  def destroy
    Problem.find(params[:id]).destroy
    flash[:success] = "Problema borrado."
    redirect_to problems_url
  end

  def update
  end
end


