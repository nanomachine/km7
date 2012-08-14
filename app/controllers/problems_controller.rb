class ProblemsController < ApplicationController
  def new
  end

  def show
    @problem = Problem.find(params[:id])
  end

  def index
  end

  def create
  end

  def destroy
  end

  def update
  end
end
