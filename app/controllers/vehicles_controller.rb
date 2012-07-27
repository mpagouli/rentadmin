class VehiclesController < ApplicationController

	before_filter :signed_in_user
	before_filter :admin_user
	before_filter :select_admin_menu

	def index
		select_item('list')
		@vehicles = Vehicle.paginate(page: params[:page])
		@vehicles_odd = @vehicles.values_at(* @vehicles.each_index.select {|i| i.even?})
		@vehicles_even = @vehicles.values_at(* @vehicles.each_index.select {|i| i.odd?})
		@help_href = '#'
	end

	def new
		select_item('new')
		@vehicle = Vehicle.new
		@help_href = '#'
	end

	def create
		@make = params[:make][:id].blank? ? nil : Make.find(params[:make][:id])
		@model = params[:model][:id].blank? ? nil : Model.find(params[:model][:id])
		@vehicle = @model.nil? ? Vehicle.new(:reg_no => params[:reg_no]) : @model.vehicles.build(:reg_no => params[:reg_no])
		if @vehicle.save
		    flash[:success] = "Vehicle inserted successfully!"
		    redirect_to @vehicle
		else
		    render 'new'
		end
	end

	def show
		@vehicle = Vehicle.find(params[:id])
	end

	def edit
		@vehicle = Vehicle.find(params[:id])
	end

	def update
		@vehicle = Vehicle.find(params[:id])
		@old_model = @vehicle.model
		@make = params[:make][:id].blank? ? nil : Make.find(params[:make][:id])
		@model = params[:model][:id].blank? ? nil : Model.find(params[:model][:id])
		@vehicle.model = @model
		if @vehicle.save
		#if @vehicle.update_attributes( :reg_no => params[:reg_no], :model_id => params[:model][:id] )
		    flash[:success] = "Vehicle updated successfully!"
		    redirect_to @vehicle
		else
			@vehicle.model = @old_model
		    render 'edit'
		end
	end

	def destroy
		Vehicle.find(params[:id]).destroy
    	flash[:success] = "Vehicle destroyed."
		redirect_to vehicles_path
	end

	#Ajax
	def filter_models
		#return render :text => "Param is #{params[:make_id]}"
		@models = Model.where("make_id = ?", params[:make_id])
		 respond_to do |format|
        	format.json { render :json =>  @models }
    	end
	end

end
