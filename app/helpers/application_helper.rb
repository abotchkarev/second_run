module ApplicationHelper
  
  def logo
    image_tag("rails.png", :alt => "Your Logo here", :class => "round")
  end
end
