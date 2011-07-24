class PagesController < ApplicationController
  
  def home
    unless signed_in?
      @title = "Welcome to the system!"
    else
      @active_count = (
        all_active = current_user.appointments.where(:active => true)
      ).size
      
      @paused_count = all_active.map{|a| a.pause}.count(true)
            
      @active_paginated = all_active.paginate(:per_page => 3, 
        :page => params[:active_page], :order => 'created_at DESC')
     
      inactive_project_ids = current_user.assignment_ids - 
        all_active.map {|a| a.relationship.project_id}
      
      @projects_to_add = inactive_project_ids.map {|id| [Project.find(id).title, 
          current_user.relationships.find_by_project_id(id).id] }  
      
      @new_appointment = Appointment.new
      
      @work_history = current_user.appointments.where(:active => false).
        paginate(:per_page => 5, :page => params[:history_page], :order => 'end_time DESC')
    end
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

  def help
    @title = "Help"
  end
end
