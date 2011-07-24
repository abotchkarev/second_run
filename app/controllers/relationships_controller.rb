class RelationshipsController < ApplicationController

  before_filter :authenticate
  before_filter :verify_request_params

  def create
    @project.relationships.create!(:user_id => @user.id)
    flash[:success] = "Relationship created"
    send_back
  end

  def destroy
    @project.relationships.find_by_user_id(@user).destroy
    flash[:success] = "Relationship destroyed"
    send_back
  end
  
  def send_back
    respond_to do |format|
      format.html {redirect_to(params[:return_to] || user_path(current_user)) }
      format.js
    end
  end
  
  private
  
  def verify_request_params
    if params[:relationship].nil?
      flash[:error] = "Incorrect request" 
      user_path(current_user)
    end
    
    @user = User.find_by_id(params[:relationship][:user_id])
    
    unless current_user.subordinates.include?(@user)
      flash[:error] = "Not subordinate" 
      user_path(current_user)
    end
    
    @project = Project.find_by_id(params[:relationship][:project_id])
    
    unless current_user.assignments.include?(@project)
      flash[:error] = "Cannot work on this project" 
      user_path(current_user)
    end
  end
end
