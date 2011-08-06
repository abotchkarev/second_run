class PagesController < ApplicationController
   
  include AppointmentsHelper
   
  def home
    if signed_in?
      @new_appointment = Appointment.new
      active_and_activatable
      @work_history = current_user.history(params[:history_page])
    else
      @title = "Welcome to the system!"
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
