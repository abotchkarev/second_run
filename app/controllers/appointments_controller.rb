class AppointmentsController < ApplicationController

  include AppointmentsHelper
  
  before_filter :authenticate
  before_filter :extract_commit
  before_filter :correct_create, :only => :create
  before_filter :correct_update, :only => :update

  def create       # Creating new, so setting time_factor += 1
    @time_factor = (@in_progress = current_user.running_apps).size + 1 
    @app_to_create.save_running_with(@time_factor) 
    @in_progress.delete_if {|f| f == @app_to_create}
    restart_respond_and_flash(@app_to_create.id)
  end
    
  def update
    @appointment.attributes = params[:appointment]
    @time_factor = (@in_progress = current_user.running_apps.
        delete_if{|a| a == @appointment}).size
    msg = "#{params[:id]} success"
    
    case @commit
      
    when "Update"
      @appointment.save 
      @in_progress = []
    when "Pause"    
      @appointment.put_on_pause      
    when "Resume"
      @time_factor += 1 
      @appointment.save_running_with(@time_factor)
    when "Finish"
      @appointment.pause ? @in_progress = [] : @appointment.put_on_pause 
      @appointment.save_inactive 
    else   
      @in_progress = [] 
      msg = "Error! commit = " + @commit.to_s
    end  
    restart_respond_and_flash(msg)
  end
  
  def destroy
    current_user.appointments.find_by_id(params[:id]).destroy
    @in_progress = []
    restart_respond_and_flash("#{params[:id]} success")
  end
  
  def restart_respond_and_flash(msg)
    @in_progress.each {|f| f.restart_with(@time_factor)}
    flash[:notice] = "#{@commit} #{msg} (#{request.format} request)"   
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js do
        active_and_activatable unless ["Delete"].include?(@commit)
        @work_history = current_user.history(params[:history_page]) if ["Finish", "Delete"].include?(@commit)
        @new_appointment = Appointment.new if ["Start", "Finish"].include?(@commit)
      end
    end
  end
  
  private
  
  def extract_commit
    @commit = (params[:commit].nil? ? "Delete" : params[:commit])
  end
  
  def correct_create
    @app_to_create = Appointment.new(params[:appointment])
    if  @app_to_create.nil? || 
        @app_to_create.relationship.nil? ||
        !current_user?(@app_to_create.relationship.user)
      flash[:error] = "Create new appointment request rejected" 
      redirect_to root_path
    end
  end
  
  def correct_update
    @appointment = Appointment.find_by_id(params[:id])
    if @appointment.nil? || 
        !@appointment.active? ||
        !current_user?(@appointment.relationship.user) ||
        (@commit == "Pause" && @appointment.pause?) ||
        (@commit == "Resume" && !@appointment.pause?)
      flash[:error] = "Update appointment request rejected" 
      redirect_to root_path
    end
  end
end
