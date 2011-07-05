class RelationshipsController < ApplicationController

  before_filter :authenticate

  def create
    @user = User.find(params[:relationship][:user_id])
    @project = Project.find(params[:relationship][:project_id])
    if current_user.subordinates.include?(@user) && current_user.projects.include?(@project)
      @project.relationships.create!(:user_id => @user.id)
    end
    respond_to do |format|
      format.html { redirect_to @project }
      #  format.js
    end
  end

  def destroy
    @user = User.find(params[:relationship][:user_id])
    @project = Project.find(params[:relationship][:project_id])
    if current_user.subordinates.include?(@user) && current_user.projects.include?(@project)
      @project.relationships.find_by_user_id(@user).destroy
    end
    respond_to do |format|
      format.html { redirect_to @project }
      #  format.js
    end
  end
end
