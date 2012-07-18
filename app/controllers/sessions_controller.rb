class SessionsController < ApplicationController
	
	def new
		if current_user
			redirect_to home_path
		end
		# Signin page should contain a "Help" link with specific href
		@help_href = help_path
	end
	
	def create
		user = User.find_by_email(params[:session][:email])
	    if user && user.authenticate(params[:session][:password])
	      sign_in user
      	  redirect_back_or home_path
	    else
	      #flash.now[:error] = 'Invalid email or password'
      	  #render 'new'
      	  flash[:error] = 'Invalid email or password'
      	  redirect_to signin_path
	    end
	end

	def destroy
      sign_out
      redirect_to signin_path
    end

end
