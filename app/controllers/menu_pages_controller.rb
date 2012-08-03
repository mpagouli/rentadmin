class MenuPagesController < ApplicationController
  
  before_filter :signed_in_user
  before_filter :admin_user, only: :admin 

  def admin
    unselect_item
  	select_menu('admin')
    # Admin page should contain a "Help" link with specific href
  	@help_href = '#'
  end

  def operation
    unselect_item
  	select_menu('operation')
    # Operation page should contain a "Help" link with specific href
  	@help_href = '#'
  end

  def board
    unselect_item
  	select_menu('board')
    # Board page should contain a "Help" link with specific href
  	@help_href = '#'
  end

end
