class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :set_gon_values
  include SessionsHelper

  private

#Used in custom.js.erb to populate donutchart
#this should be implemented by retreiving a hash with
#ptype as key and count as value

  def set_gon_values
    gon.holes = Problem.where(ptype: 1 ).count  # or whatever you want to set here
    gon.water = Problem.where(ptype: 2 ).count  # or whatever you want to set here
    gon.electric = Problem.where(ptype: 3 ).count  # or whatever you want to set here
    gon.light = Problem.where(ptype: 4 ).count  # or whatever you want to set here
    gon.debris = Problem.where(ptype: 5 ).count  # or whatever you want to set here
    gon.vandalism = Problem.where(ptype: 6 ).count  # or whatever you want to set here
    gon.manhole = Problem.where(ptype: 7 ).count  # or whatever you want to set here

    

  end

end
