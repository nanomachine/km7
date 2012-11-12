class ProblemsController < ApplicationController

  def new
    @problem = Problem.new
  end

  def show
    @problem = Problem.find(params[:id])
    @json = @problem.to_gmaps4rails

  end

  def index
    @problems = Problem.paginate(page: params[:page])
    #@json = Problem.all.to_gmaps4rails
    @json = Problem.all.to_gmaps4rails do |problem, marker|
      marker.picture({
                :picture => "/assets/markers/#{problem.ptype}.png",
                :width   => 32,
                :height  => 35
                 })
      marker.title   "i'm the title"
      marker.sidebar "i'm the sidebar"
      marker.json({ :id => problem.id})
  end

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

#Parameters: {"utf8"=>"√", "authenticity_token"=>"yuxdf1QkhDuuRnAV+qVSTjt0aq3Yo1sW9UN685GhEMc=", 
#  "problem"=>{"user"=>"7876483097", "latitude"=>"18.378383", "longitude"=>"-67.026201", "ptype"=>"2", 
#    "description"=>"Poste roto"}, "commit"=>"Guardar problema"}
