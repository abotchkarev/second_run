class UsersController < ApplicationController
  
  before_filter :authenticate
  before_filter :get_user, :except => [:index, :new, :create]
  before_filter :current_or_admin, :only => [:edit, :update]
  before_filter :admin_only,   :only => [:new, :create, :destroy, :admin]
  

  def index
    @page_id = "Catalogue"
    @title = "Catalogue of Users"
    @users = User.search(params[:search], params[:page])
  end

  def show
    @page_id = "Projects"
    @title = @user.name     
    @projects = (current_user?(@user) || current_user?(@user.chief) ?
        @user.assignments : @user.assignments & current_user.assignments
    ).paginate( :per_page => 5, :page => params[:page])    
    @projects_available = (current_user?(@user.chief) ? 
        (@user.chief.assignments - @user.assignments) : [])
  end

  def new
    @page_id = "New user"
    @user = User.new
    subordination_setup("Sign up")
  end
    
  def create
    @user = User.new(params[:user]) 
    if @user.save 
      redirect_to(@user, :notice => "New account created!")  
    else
      @user.password = @user.password_confirmation = ""
      subordination_setup("Sign up")
      render 'new'
    end
  end
  
  def edit
    @page_id = @title = "Edit user"
  end
  
  def update
    if @user.update_attributes(params[:user])
      redirect_to(@user, :notice => "Profile updated.")
    else
      @title = "Edit user"
      @user.password = @user.password_confirmation = ""
      render 'edit'
    end
  end
  
  def destroy
    if current_user?( @user )
      flash[:alert] = "This account cannot be deleted!"
    else
      @user.destroy
      flash[:notice] = "Account destroyed."
    end
    redirect_to users_path
  end
   
  def admin
    @page_id = "Admin"
    subordination_setup("Administring the Account ", @user.chief)
  end
  
  def group
    @page_id = "Group"
    @title = "Group of #{@user.name}"
    @users = @user.subordinates.delete_if{|f| f == @user}.
      paginate( :per_page => 10, :page => params[:page])
    render 'index'
  end

  def subordination_setup(title, chief = current_user.subordinates.first)
    @title = title
    @user.build_subordination if @user.subordination.nil?
    @default_chief = chief
    user_tree = [@user]
    @chief_candidates = ( @user.admin ? [chief] :
       User.all - user_tree.each{|u| u.subordinates.each {|f| user_tree << f }})
    end
  
    private

    def get_user
      @user = User.find_by_id(params[:id])
    end
  
    def current_or_admin
      redirect_to(root_path) unless current_user?(@user) || current_user.admin?
    end
  
    def admin_only
      redirect_to(root_path) unless current_user.admin?
    end
  end

