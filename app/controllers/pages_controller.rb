class PagesController < ApplicationController
  
  def home
    @title = "Home"
     @project = Project.new if signed_in?
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
