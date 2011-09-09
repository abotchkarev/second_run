class PagesController < ApplicationController
   
  include AppointmentsHelper
   
  def home
     @page_id = "Home"
    if signed_in?    
      @new_appointment = Appointment.new
      active_and_activatable
      @work_history = current_user.history(params[:history_page])
    else
      @title = "Welcome to the system!"
    end
  end
  
  def contact
    @page_id = @title = "Contact"
  end

  def about
    @page_id = @title = "About"
   
  end

  def help
    @page_id = @title = "Help"
  end
end
