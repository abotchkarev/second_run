class ProjectsController < ApplicationController
  
  before_filter :authenticate
 
  before_filter :group, :only => :show
  before_filter :owner, :only => :destroy
  
  def new
    @title = "Create new project"
    @project = Project.new
    @project.relationships.build
  end
  
  def create
    @project  = current_user.projects.new(params[:project])
    if @project.save
      flash[:success] = "Project created!"
      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end

  def show
    @people_available = (current_user.subordinates - @project_team).
      map {|f| [f.name, f.id]}
    flash[:error] = "Accomplishments section to be written"
  end
  
  def destroy
    @project = current_user.projects.find_by_id(params[:id])
    @project.destroy
    flash[:success] = "Project deleted"
    redirect_to user_path(current_user)
  end

  private

  def owner
    @project = Project.find_by_id(params[:id])
    redirect_to current_user if @project.nil? || !current_user?(@project.user)
  end
  
  def group
    @project = Project.find_by_id(params[:id]) 
    if @project.nil?
      flash[:error] = "Project not found" 
      redirect_to  user_path(current_user)
    end 
    @project_team = @project.executors
    unless @project_team.include?(current_user)
      flash[:error] = "You are not authorized to access this information" 
      redirect_to user_path(current_user)
    end
  end
end


