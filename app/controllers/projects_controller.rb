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
    project  = current_user.projects.new(params[:project])  
    project.save ? redirect_to(current_user, :notice => "Project created!") : 
      render('new')  
  end

  def show
    @people_available = current_user.subordinates - @project_team
    @appointments = @project.appointments.where(:active => false).
     paginate(:per_page => 5, :page => params[:page], :order => 'end_time DESC')   

  end
  
  def destroy
    current_user.projects.find_by_id(params[:id]).destroy
    redirect_to current_user, :alert => "Project deleted!"
  end

  private

  def owner
    @project = Project.find_by_id(params[:id])
    redirect_to current_user if @project.nil? || !current_user?(@project.user)
  end
  
  def group
    @project = Project.find_by_id(params[:id]) 
    redirect_to(current_user, :alert => "Project not found") if @project.nil? 
    
    @project_team = @project.executors    
    redirect_to(current_user, :alert => "Access restricted (project team only)"
    ) unless @project_team.include?(current_user)
  end
end


