class PagesController < ApplicationController
  
  def home
    @title = "Home"
    if signed_in?
      
      # === Just temporarary ! Need to re-define @all_projects  
      all_projects =  current_user.assignments
      
      #@active_records = current_user.progress.find_by_active(true)
      #@active_projects = []
      #@to_activate = all_projects.map {|f| [f.title, f.id]}
      #@active_projects = (@active_records.nil?) ? @active_records.map {|f| f.relationship.project} : [] 
      #to_activate = all_projects - @active_projects
      # @to_activate = (to_activate.nil?) ? to_activate.map {|f| [f.title, f.id]} : []  # generate options for Select
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
