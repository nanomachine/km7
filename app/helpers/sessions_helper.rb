module SessionsHelper

=begin

	def sign_in_remember(user)

		cookies.permanent[:remember_token] = user.remember_token
		self.current_user = user
		#puts "hice sign in permanente--------------------------"
		#puts current_user.name


		#remember_token = User.remember_token
		#cookies[:remember_token] = { value:   remember_token,
        #                     		expires: 1.minute.from_now.utc }
        #user.update_attribute(:remember_token, User.encrypt(remember_token))
		#self.current_user = user
	end

	def sign_in(user)

		remember_token = user.remember_token
		cookies[:remember_token] = {value: remember_token, expires: 8.hours.from_now.utc}
#----------------------------When token expires redirect to login
		self.current_user = user
		#puts "NO hice sign in permanente--------------------------"
		#puts current_user.name

	end

	def signed_in?
		!current_user.nil?
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token]) if cookies[:remember_token]
	end

	def current_user?(user) 	
		user == current_user
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	def store_location
		session[:return_to] = request.fullpath
	end
=end

	
end

