class AppointmentsController < ApplicationController

  before_filter :authenticate
  before_filter :correct_create, :only => :create
  before_filter :correct_update, :only => :update

  def create
    time_factor = (apps_in_progress = current_user.apps_in_progress
    ).size + 1  # Creating new, so "+1"
    apps_in_progress.each {|f| f.restart_with(time_factor)}
    @new_app.save_running_with(time_factor) ? 
      flash[:success] = "New appointment created" :
      flash[:error] = "Failed to creat new appointment" 
    redirect_to root_path
  end

  def update
    @appointment.summary = params[:appointment][:summary]
    time_factor = (apps_in_progress = current_user.apps_in_progress.
        delete_if{|a| a == @appointment}).size # Exclude @appointment, if present

    case params[:commit]
    when "Update"
      @appointment.save
      apps_in_progress = []
    when "Pause"    
      @appointment.put_on_pause      
    when "Resume"
      time_factor += 1
      @appointment.save_running_with(time_factor)
    when "Finish" 
      @appointment.save_inactive
      apps_in_progress = [] if @appointment.pause?
    else   
      apps_in_progress = []
      msg_type = :error
    end
    
    apps_in_progress.each {|f| f.restart_with(time_factor)}
    msg_type ||= :success
    flash[msg_type] = "#{params[:commit]} #{msg_type.to_s}" 
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end
  
  def destroy
    @appointment = current_user.appointments.find_by_id(params[:id])
    @appointment.destroy
    flash[:success] = "Appointment deleted"
    redirect_to root_path
  end
  
  private
  
  def correct_create
    @new_app = Appointment.new(params[:appointment])
    if  @new_app.nil? ||
        @new_app.relationship.nil? ||
        !current_user?(@new_app.relationship.user)
      flash[:error] = "Incorrect parameters for create new appointment" 
      redirect_to root_path
    end
  end
  
  def correct_update
    @appointment = Appointment.find_by_id(params[:id])
    if @appointment.nil? || 
        !@appointment.active? ||
        !current_user?(@appointment.relationship.user) ||
        (params[:commit] == "Pause" && @appointment.pause?) ||
        (params[:commit] == "Resume" && !@appointment.pause?)
      flash[:error] = "Incorrect/inconsistent parameters for Appointment update" 
      redirect_to root_path
    end
  end
end
