class VehiclesController < ApplicationController

	def index
		select_item('list')
		#@vehicles = Vehicle.all
	end

	def new
		select_item('new')
	end

	def create
	end

	def edit
	end

	def update
	end

	def destroy
	end

end
