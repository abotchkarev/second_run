
class SubordinationsController < ApplicationController
  
  before_filter :authenticate
  before_filter :admin_user
  
  def update
    Subordination.find(params[:id]).
      update_attributes(params[:subordination])
    redirect_to(:back, :notice => "Subordination updated.")
  end
  
  private
  
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
