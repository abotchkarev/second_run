class RelationshipsController < ApplicationController

  before_filter :authenticate
  before_filter :verify_request_params

  def create
    @project.relationships.create!(:user_id => @user.id)
    flash[:success] = "Relationship created"
    #flash[:success] = params[:return_to].to_s
    send_back
  end

  def destroy
    @project.relationships.find_by_user_id(@user).destroy
    flash[:success] = "Relationship destroyed"
    #  flash[:success] = params[:return_to].to_s
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
    flash[:error] = "Incorrect parameters",
      user_path(current_user) if params[:relationship].nil?
    @user = User.find_by_id(params[:relationship][:user_id])
    flash[:error] = "Error! This person is not your subordinate.", 
      user_path(current_user) unless current_user.subordinates.include?(@user)
    @project = Project.find_by_id(params[:relationship][:project_id])
    flash[:error] = "You are not working on this Project", 
      user_path(current_user) unless current_user.assignments.include?(@project)
  end
end
