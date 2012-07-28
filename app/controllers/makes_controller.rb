class MakesController < ApplicationController
  
  def new
  	@make = Make.new
  	render :new, :layout => false
  end

  #Ajax
  def savemake
	#return render :text => "Param is #{params[:make_name]}"
	@make = Make.new(make_name: params[:make_name], description: params[:make_description])
	respond_to do |format|
	  if @make.save
        format.json { render :json =>  { make: @make, errors: nil, success:true } }
      else
      	@errors = []
      	@make.errors.each do |key,value|
      		@errors.push(value)
      	end
      	format.json { render :json =>  { make: @make, errors: @errors, success:false } }
      end
    end
  end

end
