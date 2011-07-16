class UsersController < ApplicationController
  
  before_filter :authenticate
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => [:new, :create, :destroy]

  def index
    users_per_page = 15
    @title = "Catalog of Users"
    @users = User.paginate(:page => params[:page], 
      :per_page => users_per_page)
  end

  def show
    projects_per_page = 5
    @user = User.find_by_id(params[:id])
    @title = @user.name
    @projects_available = [] # not empty for subordinates only
   
    @assignments = (case current_user
      when @user        # my home page
        current_user.assignments
      when @user.chief  # chief visits on my home
        @projects_available = (@user.chief.assignments - @user.assignments).
          map {|f| [f.title, f.id]}
        @user.assignments
      else    # other pages (only our common assignments)
        @user.assignments & current_user.assignments
      end
    ).paginate(:page => params[:page], :per_page => projects_per_page)
  end

  def new
    @title = "Sign up"
    @managers_list = User.manager.map {|f| [f.name, f.id]}
    @default_chief = @managers_list[0][1]
    @user = User.new
  end
  
  def create
    params[:manager] = (params[:manager] == "true") ? true : false # convert text to boolean
    @user = User.new(params[:user])
    if @user.save
      #sign_in @user
      flash[:success] = "New account created!"
      redirect_to @user
    else
      @user.password = @user.password_confirmation = ""
      @title = "Sign up"
      render 'new'
    end
  end
  
  def edit
    @managers_list = User.manager.delete_if{|f| f == @user}.map {|f| [f.name, f.id]}
    
    @current_chief = @user.chief_id
    @default_manager = @user.manager
    @title = "Edit user"
  end
  
  def update
    # convert ascii to boolean
    params[:manager] = (params[:manager] == "true") ? true : false 
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    if current_user?(User.find(params[:id]))
      flash[:error] = "You cannot delete your own account!"
    else
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_path
  end
  
  private
  
  def correct_user
    @user = User.find(params[:id].to_i)
    redirect_to(root_path) unless current_user?(@user) || current_user.admin?
  end
  
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end

