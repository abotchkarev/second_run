
class ProjectsController < ApplicationController
  
  before_filter :authenticate
  # before_filter :manager, :only => :create
  # before_filter :group, :only => :view
  before_filter :authorized_user, :only => :destroy
  
  def create
    @project  = current_user.projects.build(params[:project])
    if @project.save
      flash[:success] = "Project created!"
      redirect_to root_path
    else
      render 'pages/home'
    end
  end

  def show
    @project = current_user.projects.find_by_id(params[:id])
    @team = @project.executors
    #@available = [["a",1],["b",2]]
   @available = (current_user.subordinates - @team).map {|f| [f.name, f.id]}
    flash[:error] = "Accomplishments sections to be written"
  end
  
  def destroy
    @project = current_user.projects.find(params[:id])
    @project.destroy
    flash[:success] = "Project deleted"
    redirect_to user_path(current_user)
  end
  
  private

  def authorized_user
    @project = current_user.projects.find(params[:id])
    redirect_to user_path(current_user) if @project.nil?
  end
  
  def manager
    # user.manager?
    true
  end
  
  def group
    true
  end
end

