class ProblemsController < ApplicationController

  def new
    @problem = Problem.new
    @lists = List.all
  end

#Show report details and only show selected problem in gmap
  def show
    @problem = Problem.find(params[:id])
    @json = @problem.to_gmaps4rails do |problem, marker|
      marker.picture({
                :picture => "/assets/markers/#{problem.ptype}.png",
                :width   => 32,
                :height  => 35
                 })
      marker.title   "#{problem.title}"
      marker.json({ :id => problem.id})
    end
  end

#Show list of reports and show all of them in gmap
  def index
    @problems = Problem.paginate(page: params[:page])
  end

  def create
    @problem = Problem.new(params[:problem])
#Para obtener el usuario actual que está creando el reporte sólo funciona
#por webapp. Su motivo aplicar relación belongs_to de "problems"

#This works only for dev purposes for submitting reports from the web application 
#and set the curret_user as the reporting, if the submitting problem has no id
#assing the current_user as owner.
    if !@problem.user_id
      @problem.user_id = current_user.id
    end
#Geocoding addresses to coordinates does not work well in Puerto Rico hence its implementationwill be postponed or abandoned
   #@geocoded = Gmaps4rails.geocode(@problem.address)
   #puts @geocoded

#When report is first created, its status is initially Unassigned, hence it is set to 1
    @problem.status = 1
    if @problem.save
      flash[:success] = "Report saved"
      #@lists.problems.create(attributes={"list_id" =>3, "problem_id" => @problem.id})
      redirect_to @problem
    else
      flash[:error] = 'Incomplete information, report not created'
      redirect_to problems_url
    end
  end

  def destroy
    Problem.find(params[:id]).destroy
    flash[:success] = "Report deleted."
    redirect_to problems_url
  end

  #Before_filter for these methods edit/update to confirm the user is the owner of these reports
  #as in user.rb, rails tutorial
  def edit
    @problem = Problem.find(params[:id])
  end

  def update
    @problem = Problem.find(params[:id])
    if @problem.update_attributes(params[:problem])
      flash[:success] = "Report updated"
      redirect_to @problem
    else
      flash[:error] = "Report update error"
      redirect_to @problem
    end
  end

  def add_new_comment
    @problem = Problem.find(params[:id])
    @comment = Comment.build_from( @problem, current_user.id, params[:comment][:body] )
    @comment.save!
    flash[:notice] = "Comment added!"
    redirect_to :action => :show, :id => @problem
  end

  def delete_comment
      @problem = Problem.find(params[:id])
      @comment = Comment.find(params[:comment])

      if current_user.id == @comment.user_id
          @comment.destroy
          flash[:notice] = "Comment deleted!"
      else
          flash[:notice] = "Sorry, you can't delete this comment"
      end
      redirect_to :action => :show, :id => @problem
  end

=begin  
  def get_last_month_reports
    @last_month = 0
    Problem.all.each do |problem|
      if problem.created_at.month == Time.1.month.ago
        @last_month = @last_month +1
      end
    end
    return @last_month
  end



def get_before_last_month_reports
    @before_last_month = 0
    Problem.all.each do |problem|
      if problem.created_at.month == 2.month.ago
        @last_month = @last_month +1
      end
    end
    return @last_month
  end
=end

#    def get_type_count
#    @report_type_count = Problem.where("ptype = 1").count
#
#    return @report_type_count
#    end

#Parameters: {"utf8"=>"√", "authenticity_token"=>"yuxdf1QkhDuuRnAV+qVSTjt0aq3Yo1sW9UN685GhEMc=", 
#  "problem"=>{"user"=>"7876483097", "latitude"=>"18.378383", "longitude"=>"-67.026201", "ptype"=>"2", 
#    "description"=>"Poste roto"}, "commit"=>"Guardar problema"}
end