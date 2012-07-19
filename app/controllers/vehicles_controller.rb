class VehiclesController < ApplicationController

	before_filter :signed_in_user
	before_filter :admin_user
	before_filter :select_admin_menu

	def index
		select_item('list')
		@vehicles = Vehicle.paginate(page: params[:page])
		@help_href = '#'
	end

	def new
		select_item('new')
	end

	def create
	end

	def show
	end

	def edit
	end

	def update
	end

	def destroy
		redirect_to users_path
	end

end
