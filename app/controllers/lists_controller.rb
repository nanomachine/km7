class ListsController < ApplicationController
#require 'zip/zip'

def new
    @list = List.new
    @problems= Problem.all
  end

#Show report details and only show selescted problem in gmap
  def show
    @list = List.find(params[:id])
    @problems = Problem.paginate(page: params[:page])

    #Respond to will create a call to csv and prepare the list for .xls exporting
    #See lists/show.xls.erb for table formatting details
    respond_to do |format|
      format.html # index.html.erb
      format.xlsx{
        render :xlsx => "show", :filename => "#{@list.id}-#{@list.name}-#{@list.created_at.strftime("%b.%d %Y")}.xlsx"
      }
    end
  end


#Show list of reports and show all of them in gmap
  def index
    @lists = List.paginate(page: params[:page])

  end

  def create
    @list = List.new(params[:list])
#Para obtener el usuario actual que esta creando el reporte solo funciona
#por webapp. Su motivo aplicar relación belongs_to de "problems"
    @list.user_id = current_user.id
#Activate the list when it is created, enabling it for use
#If list is closed it will only be browsable, not editable
    @list.active = true

    if @list.save
      flash[:success] = "List saved"
      redirect_to @list
    else
      flash[:error] = 'Incomplete information, list not created'
      redirect_to  lists_path 
    end
  end

  def destroy
# Unassign all contained reports unless already resolved
    @list = List.find(params[:id])
    @list.problems.each do |problem|
      if problem.status!=3
        problem.status = 1
        problem.save
      end
    end
    @list.destroy
    flash[:success] = "List deleted."
    redirect_to lists_url
  end

  def edit
    @list = List.find(params[:id])
  end

  def update
    @list = List.find(params[:id])
      if @list.update_attributes(params[:list])
        flash[:success] = "List updated"
        redirect_to @list
      else
        flash[:error] = "List update error"
        redirect_to @list
      end
  end

  def add_problem
    @list    = List.find(params[:id])
    @problem = Problem.find(params[:problem_id])

    if !@list.problems.include?(@problem)
      @list.problems << @problem # This appends and saves the problem selected
      #Change the report status, it is now assigned to the owner of the list
      @problem.status = 2
      @problem.assigned_at = Time.now
      @problem.save
      flash[:notice] = "Report added"
      redirect_to @list
    else 
      flash[:notice] = "Report is already on the list"
      redirect_to @list
    end

  end

  def remove_problem
    @list    = List.find(params[:id])
    @problem = Problem.find(params[:problem_id])
    #Change the report status back to being unassigned
    if @problem.status!= 3
      @problem.status = 1
      @problem.save
    end
    @list.problems.destroy(@problem) # This removes the problem selected
    flash[:notice] = "Report removed"


    redirect_to @list 
  end


#  def validates_role(role)
#    raise ActiveRecord::Rollback if self.roles.include? role
#  end

#  def show_problems
#    @list = List.find(params[:id])
#  end

#  def save
#  @list = List.find(params[:id])
#  @problem = Problem.find(params[:problem])
#  if params[:show] == "true"
#    @list.problems << @problem
#  else
#    @list.problems.delete(@problem)
#  end
#  @list.save!
#  render :nothing => true
#  end

end
