class ClientsController < ApplicationController

  before_filter :signed_in_user
  before_filter :admin_user
  before_filter :select_admin_menu

  def index
    select_item('client_list')
    @clients = Client.paginate(page: params[:page])
    @help_href = '#'
  end

  def new
  end

  def destroy
	Client.find(params[:id]).destroy
    flash[:success] = "Customer removed from the database."
	redirect_to :back
  end


end
