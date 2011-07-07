
class ProjectsController < ApplicationController
  
  before_filter :authenticate
  # before_filter :manager, :only => :create
  before_filter :group, :only => :show
  before_filter :owner, :only => :destroy
  
  def new
    @title = "Home"
    @project = Project.new
  end
  
  def create
    @project  = current_user.projects.build(params[:project])
    if @project.save
      flash[:success] = "Project created!"
      redirect_to user_path(current_user)
    else
      render 'pages/home'
    end
  end

  def show
    @available = (current_user.subordinates - @team).map {|f| [f.name, f.id]}
    store_location
    flash[:error] = "Accomplishments section to be written"
  end
  
  def destroy
    @project = current_user.projects.find(params[:id])
    @project.destroy
    flash[:success] = "Project deleted"
    redirect_to user_path(current_user)
  end
  
  private

  def owner
    @project = Project.find(params[:id])
    redirect_to current_user if @project.nil? || !current_user?(@project.user)
  end
  
  #def manager
  # user.manager?
  #end
  
  def group
    @project = Project.find(params[:id]) 
    flash[:error] = "Project not found",  current_user  if @project.nil?
    @project_manager = @project.user
    @team = @project.executors
    redirect_to current_user unless current_user?(@project_manager) || @team.include?(current_user) 
  end
end


