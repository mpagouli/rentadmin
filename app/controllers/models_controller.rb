class ModelsController < ApplicationController
  
    before_filter :signed_in_user
	before_filter :admin_user
	before_filter :select_admin_menu

	#def index
	#	@models = Model.paginate(page: params[:page]).sort!{|m1,m2|m1.id <=> m2.id}
	#	@help_href = '#'
	#end

	def new
		@model = Model.new
		#@help_href = '#'
		render :new, :layout => false
	end

    #Ajax
    def savemodel
	  #return render :text => "Param is #{params[:makeid]}"
	  @model = Make.find(params[:makeid]).models.build(model_name: params[:model_name], description: params[:model_description])
	  respond_to do |format|
	    if @model.save
          format.json { render :json =>  { model: @model, errors: nil, success:true } }
        else
      	  @errors = []
      	  @model.errors.each do |key,value|
      		@errors.push(value)
      	  end
      	  format.json { render :json =>  { model: @model, errors: @errors, success:false } }
        end
      end
    end

	#def create
	#	#return render :text => "Param is #{Make.find(params[:makeid]).models.count}"
	#	@model = Make.find(params[:makeid]).models.build(:model_name => params[:model_name], :description => params[:model_description])
	#  	respond_to do |format|
	#    if @model.save
    #      format.json { render :json =>  { model: @model, errors: nil, success:true } }
    #    else
    #  	  @errors = []
    #  	  @model.errors.each do |key,value|
    #  		@errors.push(value)
    #  	  end
    #  	  format.json { render :json =>  { model: @model, errors: @errors, success:false } }
    #    end
    #  end
	#end
#
	#def show
	#	@vehicle = Vehicle.find(params[:id])
	#end

	#def edit
	#	@vehicle = Vehicle.find(params[:id])
	#end

	#def update
	#	@vehicle = Vehicle.find(params[:id])
	#	@old_model = @vehicle.model
	#	@make = params[:make][:id].blank? ? nil : Make.find(params[:make][:id])
	#	@model = params[:model][:id].blank? ? nil : Model.find(params[:model][:id])
	#	@vehicle.model = @model
	#	if @vehicle.save
	#	#if @vehicle.update_attributes( :reg_no => params[:reg_no], :model_id => params[:model][:id] )
	#	    flash[:success] = "Vehicle updated successfully!"
	#	    redirect_to @vehicle
	#	else
	#		@vehicle.model = @old_model
	#	    render 'edit'
	#	end
	#end

	def destroy
		begin
		Model.find(params[:id]).destroy
    	  flash[:success] = "Vehicle destroyed."
		  redirect_to vehicles_path
		rescue Exception => e
			logger.error e.message
			flash.now[:error] = e.message
			render 'show'
		end
	end

end
