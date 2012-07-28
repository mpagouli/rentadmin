class MakesController < ApplicationController
  
  #def new
  #	@make = Make.new
  #	render :new, :layout => false
  #end

  #Ajax
  def savemake
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

  #Ajax
  def makeopen
    #return render :text => "Param is #{params[:make_name]}"
    if !params[:makeid].empty?
      @make = Make.find(params[:makeid])
      respond_to do |format|
          format.json { render :json =>  { make: @make, errors: nil, success:true } }
      end
    else
      respond_to do |format|
          format.json { render :json =>  { make: nil, errors: ["No make selected!"], success:false } }
      end
    end
  end

  #Ajax
  def makemodify
  #return render :text => "Param is #{params[:makeid]}"
  @make = Make.find(params[:makeid])
  #@make.make_name = params[:make_name]
  #@make.description = params[:make_description]
  respond_to do |format|
    if @make.update_attributes(:make_name => params[:make_name], :description => params[:make_description])
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

  #Ajax
  def dropmake
    begin
      Make.find(params[:makeid]).destroy
      respond_to do |format|
          format.json { render :json =>  { errors: nil, success:true } }
      end
    rescue Exception => e
      logger.error e.message
      respond_to do |format|
          format.json { render :json =>  { errors: [e.message], success:false } }
      end
    end
  end

end
