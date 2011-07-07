class UsersController < ApplicationController
  
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
    @available = []
   
    @projects = (case current_user
      when @user
        @user.assignments + @user.projects
      when @user.chief 
        @available = ((@user.chief.projects + @user.chief.assignments) -
            @user.assignments).map {|f| [f.title, f.id]}
        @user.projects + @user.assignments
      else
        @user.assignments - (@user.assignments - current_user.assignments)
      end
    ).paginate(:page => params[:page], :per_page => 5)
    store_location
  end

  def new
    @managers_list = User.manager.map {|f| [f.name, f.id]}
    @default_chief = @managers_list[0][1]
    @user = User.new
    @title = "Sign up"
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
    # @user = User.find(params[:id])
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
      flash[:error] = "You cannot delete youself!  :-)"
    else
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_path
  end
  
  def group
    users_per_page = 10
    @user = User.find(params[:id])
    @title = "Group of " + @user.name
    @users = @user.subordinates.paginate(:page => params[:page], :per_page => users_per_page)
  end
  
  def projects
    projects_per_page = 5
    @user = User.find(params[:id])
    @title = " Projects for group of " + @user.name
    @projects = (@user.projects + @user.assignments).paginate(:page => params[:page], :per_page => projects_per_page)
    #  @available = (current_user.subordinates - @team).map {|f| [f.name, f.id]} 
  end

  private
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user) || current_user.admin?
  end
  
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end

