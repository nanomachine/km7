class Api::V1::TokensController  < ApplicationController
    skip_before_filter :authenticate_user!
    #skip_before_filter :verify_authenticity_token
    respond_to :json

#To create (sign in) send an HTTP POST with http://localhost:3000/api/v1/tokens.json
#Content-Type: application/x-www-form-urlencoded
#Body: email=email@kilometrosiete.com&password=password
    def create
      email = params[:email]
      password = params[:password]
      if request.format != :json
        render :status=>406, :json=>{:message=>"The request must be json"}
        return
       end
 
    if email.nil? or password.nil?
       render :status=>400,
              :json=>{:message=>"The request must contain the user email and password."}
       return
    end
 
    @user=User.find_by_email(email.downcase)
 
    if @user.nil?
      logger.info("User #{email} failed signin, user cannot be found.")
      render :status=>401, :json=>{:message=>"Invalid email or passoword."}
      return
    end
 
    # http://rdoc.info/github/plataformatec/devise/master/Devise/Models/TokenAuthenticatable
    @user.ensure_authentication_token!
 
    if not @user.valid_password?(password)
      logger.info("User #{email} failed signin, password \"#{password}\" is invalid")
      render :status=>401, :json=>{:message=>"Invalid email or password."}
    else
      render :status=>200, :json=>{:token=>@user.authentication_token}
    end
  end
 

#To destroy (sign out) send an HTTP Delete with https://km7.herokuapp.com/api/v1/tokens/(authentication_token).json
#Content-Type: application/x-www-form-urlencoded
#To reset token the user must sign out from mobile app, otherwise it will continue using the
#same authentication token
  def destroy
    @user=User.find_by_authentication_token(params[:id])
    if @user.nil?
      logger.info("Token not found.")
      render :status=>404, :json=>{:message=>"Invalid token."}
    else
      @user.reset_authentication_token!
      render :status=>200, :json=>{:token=>params[:id]}
    end
  end
 
end