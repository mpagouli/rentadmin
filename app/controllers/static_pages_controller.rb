class StaticPagesController < ApplicationController

 before_filter :signed_in_user, only: :home

  def home
  	unselect_item
    unselect_menu
  	# Home page should contain a "Help" link with specific href
  	@help_href = help_path	
  end

  def help
  	unselect_item
    unselect_menu
  	# Help page should not contain a "Help" link
  	@help_href = nil
  end
  
end
