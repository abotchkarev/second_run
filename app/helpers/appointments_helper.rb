module AppointmentsHelper
  
  def active_and_activatable
    @active_count = (all_active = current_user.active_apps).size 
    @paused_count = all_active.map{|a| a.pause}.count(true)
    @active_paginated = all_active.paginate(:per_page => 3, 
      :page => params[:active_page], :order => 'created_at DESC')
    inactive_project_ids = current_user.assignment_ids - 
      all_active.map {|a| a.relationship.project_id}
    @projects_to_add = inactive_project_ids.map {|id| [Project.find(id).title, 
        current_user.relationships.find_by_project_id(id).id] } 
  end
end
