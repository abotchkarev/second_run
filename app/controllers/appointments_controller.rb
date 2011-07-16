class RelationshipsController < ApplicationController

  before_filter :authenticate
  before_filter :correct_request

  def create
    @project.relationships.create!(:user_id => @user.id)
    
    flash[:success] = "user_id " + @user.id.to_s + "(" + @user.name +
      ") project_id " + @project.id.to_s + " relationship added!"
    
    respond_to do |format|
      format.html { redirect_back_or @project }
      #  format.js
    end
  end

  def update
    
  end
  
  def destroy
    @project.relationships.find_by_user_id(@user).destroy
    flash[:success] = "user_id " + @user.id.to_s + "(" + @user.name + ") project_id " + @project.id.to_s + " relationship removed!" 
    respond_to do |format|
      format.html { redirect_back_or @project }
      #  format.js
    end
  end
  
  private
  
  def correct_request
    @user = User.find(params[:relationship][:user_id])
    flash[:error] = "Wrong user", user_path(current_user) unless current_user.subordinates.include?(@user)
    @project = Project.find(params[:relationship][:project_id])
    flash[:error] = "Wrong Project", user_path(current_user) unless (current_user.projects + 
        current_user.assignments).include?(@project)
  end
end
