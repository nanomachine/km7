class ApplicationController < ActionController::Base
  #protect_from_forgery with: :exception
  #include SessionsHelper
  before_filter :set_gon_values
  #before_filter :after_token_authentication
  before_filter :authenticate_user!, :except => [:about, :contact, :help]

  private

  def after_sign_in_path_for(user)
      dashboard_path
  end

  def set_gon_values

#Used in custom.js.erb to populate donutchart and stackchart
#this should be implemented by retreiving a hash with
#ptype as key and count as value

    gon.holes = Problem.where(ptype: 1 ).count 
    gon.water = Problem.where(ptype: 2 ).count 
    gon.electric = Problem.where(ptype: 3 ).count 
    gon.light = Problem.where(ptype: 4 ).count 
    gon.debris = Problem.where(ptype: 5 ).count 
    gon.vandalism = Problem.where(ptype: 6 ).count  
    gon.manhole = Problem.where(ptype: 7 ).count  

    gon.u_holes = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='1' AND status='1'").count
    gon.a_holes = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='1' AND status='2'").count
    gon.r_holes = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='1' AND status='3'").count

    gon.u_water = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='2' AND status='1'").count
    gon.a_water = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='2' AND status='2'").count
    gon.r_water = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='2' AND status='3'").count

    gon.u_electric = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='3' AND status='1'").count
    gon.a_electric = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='3' AND status='2'").count
    gon.r_electric = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='3' AND status='3'").count

    gon.u_light = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='4' AND status='1'").count
    gon.a_light = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='4' AND status='2'").count
    gon.r_light = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='4' AND status='3'").count

    gon.u_debris = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='5' AND status='1'").count
    gon.a_debris = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='5' AND status='2'").count
    gon.r_debris = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='5' AND status='3'").count

    gon.u_vandalism = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='6' AND status='1'").count
    gon.a_vandalism = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='6' AND status='2'").count
    gon.r_vandalism = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='6' AND status='3'").count

    gon.u_manhole = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='7' AND status='1'").count
    gon.a_manhole = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='7' AND status='2'").count
    gon.r_manhole = Problem.find_by_sql("SELECT * FROM problems WHERE ptype='75' AND status='3'").count
  end
end
