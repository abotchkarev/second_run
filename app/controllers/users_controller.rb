class UsersController < ApplicationController
  
  before_filter :authenticate
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => [:new, :create, :destroy]

  def index
    @title = "Catalog of Users"
    @users = User.search(params[:search], params[:page])
  end

  def show
    @user = User.find_by_id(params[:id]) 
    @title = @user.name    
    
    @projects = (current_user?(@user) || current_user?(@user.chief) ?
        @user.assignments : @user.assignments & current_user.assignments
    ).paginate( :per_page => 5, :page => params[:page])
    
    @projects_available = (current_user?(@user.chief) ? 
        (@user.chief.assignments - @user.assignments) : [])
  end

  def new
    @user = User.new
    setup_new
  end
  
  def create
    @user = User.new(params[:user]) 
    if @user.save 
      redirect_to(@user, :notice => "New account created!")  
    else
      @user.password = @user.password_confirmation = ""
      setup_new
      render 'new'
    end
  end
  
  def edit
    @title = "Edit user"
    @default_chief = @user.chief
    @chief_candidates = (current_user.admin ? User.all : [])
  end
  
  def update
    if @user.update_attributes(params[:user])
      redirect_to(@user, :notice => "Profile updated.")
    else
      @user.password = @user.password_confirmation = ""
      edit
      render 'edit'
    end
  end
  
  def destroy
    if current_user?( user = User.find(params[:id]) )
      flash[:alert] = "Cannot delete current user account!"
    else
      user.destroy
      flash[:notice] = "User destroyed."
    end
    redirect_to users_path
  end
  
  def setup_new
    @title = "Sign up"  
    @default_chief = current_user
    @chief_candidates = User.all
  end
  
  private
  
  def correct_user
    @user = User.find_by_id(params[:id])
    # params[:user].delete(:chief_id) unless current_user.admin?
    redirect_to(root_path) unless current_user?(@user) || current_user.admin?
  end
  
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end

