class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
    	# if user is authenticated do the following
    	log_in user
    	# Log the user in and redirect to the user's show page.
    	params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    	#defers the real work to the Sessions helper, where we define a remember method that calls user.remember, thereby generating a remember token and saving its digest to the database. It then uses cookies to create permanent cookies for the user id and remember token
    	redirect_back_or user
    	#Rails automatically converts this to the route for the user’s profile page
      
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end