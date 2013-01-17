class ListsController < ApplicationController

def new
    @list = List.new
    @problems= Problem.all
  end

#Show report details and only show selescted problem in gmap
  def show
    @list = List.find(params[:id])
    @problems = Problem.paginate(page: params[:page])

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
    if @list.save
      flash[:success] = "List saved"
      redirect_to @list
    else
      flash.now[:error] = 'Incorrect information'
      render 'new' 
    end
  end

  def destroy
    List.find(params[:id]).destroy
    flash[:success] = "List deleted."
    redirect_to lists_url
  end

  def update
    if @list.update_attributes(params[:list])
      flash[:success] = "List updated"
      redirect_to @list
    else
      render 'edit'
    end
  end

  #Sólo debería ver los reportes que él ha sometido?
  def candidate_problems
    Problem.find(:all)
  end

  def add_problem
    list    = List.find(params[:id])
    problem = Problem.find(params[:problem_id])

    if !list.problems.include?(problem)
      list.problems << problem # This appends and saves the problem selected
      flash[:notice] = "Report added"
      redirect_to list
    else 
      flash[:notice] = "Report is already in the list"
      redirect_to list
    end

  end

  def remove_problem
    list    = List.find(params[:id])
    problem = Problem.find(params[:problem_id])

    list.problems.destroy(problem) # This removes the problem selected
    flash[:notice] = "Report removed"


    redirect_to list 
  end

  def in_list?(problem)
    problems.include?(problem)
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
