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
    select_item('client_new')
    @client = Client.new
  end

  def destroy
	Client.find(params[:id]).destroy
    flash[:success] = "Customer removed from the database."
	redirect_to :back
  end

  def show
    @client = Client.find(params[:id])
  end

  def create
    @client = Client.new(params[:client])
    if @client.save
      flash[:success] = "Customer inserted successfully!"
      redirect_to @client
    else
      render 'new'
    end
  end

  def edit
     @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])
    if @client.update_attributes(params[:client])
      flash[:success] = "Customer updated successfully!"
      redirect_to @client
    else
      render 'edit'
    end
  end


end
