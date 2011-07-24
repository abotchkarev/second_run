class SessionsController < ApplicationController
  
  def new
    @title = "Sign in"
  end
  
  def create
    user = User.authenticate(
      params[:session][:email],
      params[:session][:password])
    if user.nil?
      if User.empty?
        create_root
      else
        flash.now[:error] = "Invalid email/password combination."
        @title = "Sign in"
        render 'new'
      end
    else
      sign_in user
      redirect_back_or user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
  
  private
  
  def create_root
    User.new(:name => "root", :email => "root@e.mail",
      :password => "123456", :password_confirmation => "123456").save
    user = User.find_by_email("root@e.mail")
    user.chief_id = user.id
    user.admin = true
    user.update_attributes(:password => "123456", :password_confirmation => "123456")
    sign_in user
    flash[:alert] = "Initializing the system. Please update the 'root' account"
    redirect_to edit_user_path(user)
  end
end
