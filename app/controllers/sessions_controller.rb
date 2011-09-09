class SessionsController < ApplicationController
  
  before_filter :create_root_if_db_empty, :only => :new 
    
  def new
    @page_id = @title = "Sign in"
  end
  
  def create
    user = User.authenticate(
      params[:session][:email],
      params[:session][:password])
    if user.nil?
      if User.all.empty?
        create_root
      else
        flash.now[:error] = "Invalid email/password combination."
        @title = "Sign in"
        render 'new'
      end
    else
      sign_in user
      flash[:info] = "Hello #{user.name}! Wecome back..."
      redirect_to root_path
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
  
  private
  
  def create_root_if_db_empty
    if User.first.nil?
      user = User.new(:name => "root", :email => "root@e.mail",
        :password => "123456", :password_confirmation => "123456")
      user.admin = true
      user.save
      user.build_subordination(:chief_id => user.id).save
      sign_in user
      flash[:alert] = "Creating root account! Please change email and password!"
      redirect_to edit_user_path(user)
    end
  end
end
