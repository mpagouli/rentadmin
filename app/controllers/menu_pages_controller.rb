class MenuPagesController < ApplicationController
  
  before_filter :signed_in_user
  before_filter :admin_user, only: :admin 

  def admin
  	select_menu('admin')
    # Admin page should contain a "Help" link with specific href
  	@help_href = '#'
  end

  def operation
  	select_menu('operation')
    # Operation page should contain a "Help" link with specific href
  	@help_href = '#'
  end

  def board
  	select_menu('board')
    # Board page should contain a "Help" link with specific href
  	@help_href = '#'
  end

end
