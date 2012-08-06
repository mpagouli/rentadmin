class GroupsController < ApplicationController
  
  #Ajax
  def savegroup
  	@group = Group.new(group_name: params[:group_name], description: params[:group_description])
  	respond_to do |format|
  	  if @group.save
        format.json { render :json =>  { group: @group, errors: nil, success:true } }
      else
        @errors = []
        @group.errors.each do |key,value|
        	@errors.push(value)
        end
        format.json { render :json =>  { make: @group, errors: @errors, success:false } }
      end
    end
  end

  #Ajax
  def groupopen
    #return render :text => "Param is #{params[:make_name]}"
    if !params[:groupid].empty?
      @group = Group.find(params[:groupid])
      respond_to do |format|
          format.json { render :json =>  { group: @group, errors: nil, success:true } }
      end
    else
      respond_to do |format|
          format.json { render :json =>  { group: nil, errors: ["No group selected!"], success:false } }
      end
    end
  end

  #Ajax
  def groupmodify
  #return render :text => "Param is #{params[:makeid]}"
  @group = Group.find(params[:groupid])
  #@make.make_name = params[:make_name]
  #@make.description = params[:make_description]
  respond_to do |format|
    if @group.update_attributes(:group_name => params[:group_name], :description => params[:group_description])
        format.json { render :json =>  { group: @group, errors: nil, success:true } }
      else
        @errors = []
        @group.errors.each do |key,value|
          @errors.push(value)
        end
        format.json { render :json =>  { group: @group, errors: @errors, success:false } }
      end
    end
  end

  #Ajax
  def dropgroup
    begin
      Group.find(params[:groupid]).destroy
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
