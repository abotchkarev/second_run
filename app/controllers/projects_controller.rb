class ProjectsController < ApplicationController
   
  before_filter :authenticate
  before_filter :group,             :only => :show
  before_filter :owner,             :only => :destroy
  
  def new
    @title = "Create new project"
    @project = Project.new
    @project.relationships.build
  end
  
  def create
    @project  = current_user.projects.new(params[:project])
    if @project.save 
      redirect_to(current_user, :notice => "New Project created!")
    else
      flash[:alert] = "Something wrong..."
      render('new')  
    end
  end

  def show
    @appointments = @project.appointments.where(:active => false).
      paginate(:per_page => 5, :page => params[:page], 
      :order => 'end_time DESC')
    @people_available = current_user.subordinates - @project_team
  end
  
  def destroy
    @project.destroy
    redirect_to current_user, :notice => "Project deleted!"
  end

  private
  
  def not_empty_project
    @project = Project.find_by_id(params[:id]) 
    redirect_to(current_user, :alert => "Project not found") if @project.nil?
  end
  
  def owner
    not_empty_project
    redirect_to current_user unless  current_user?(@project.user)
  end
  
  def group
    not_empty_project
    @project_team = @project.executors    
    redirect_to(current_user, :alert => "Access for team members only!"
    ) unless @project_team.include?(current_user)
  end
end


