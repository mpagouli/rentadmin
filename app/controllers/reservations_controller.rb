class ReservationsController < ApplicationController
	include ActionView::Helpers::TextHelper

  before_filter :signed_in_user
  #before_filter :admin_user
  before_filter :select_operation_menu, only: [:index, :new, :edit, :update, :destroy, :create, :show]

  def index
    select_item('reservation_list')
    @reservations = Reservation.where('status != ?','DELETED').paginate(page: params[:page])
    @help_href = '#'
  end

  def new
    select_item('reservation_new')
    @vehicle = Reservation.new
    @help_href = '#'
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    if @reservation.update_attributes({status: 'DELETED'})
      flash[:success] = "Reservation marked as deleted."
    end
    redirect_to :back
  end

  def create
    @reservation = Reservation.new
    @vehicle = params[:vehicle][:id].blank? ? nil : Vehicle.find(params[:vehicle][:id])
    @client = params[:client][:id].blank? ? nil : Client.find(params[:client][:id])
    #return render :text => "Status #{ReservationStatus[params[:status][:id].to_i]}"
    if !params[:pick_up_date].blank? && !params[:drop_off_date].blank?
      pickup = Time.strptime(params[:pick_up_date], '%d/%m/%Y %H:%M').in_time_zone(Time.zone)
      dropoff = Time.strptime(params[:drop_off_date], '%d/%m/%Y %H:%M').in_time_zone(Time.zone)
      @reservation = @vehicle.nil? ? @reservation : @vehicle.reservations.build(reservation_code: params[:reservation_code], pick_up_date: pickup, drop_off_date: dropoff, status: ReservationStatus[params[:status][:id].to_i])
      @reservation.client = @client
      if pickup < dropoff && !@vehicle.nil?
        other = Reservation.where(:status => ['PENDING','CONFIRMED','RUNNING'], :vehicle_id => @vehicle.id).where('pick_up_date <= ? and drop_off_date >= ?', pickup, dropoff)
        if other.empty?
          if @reservation.save
            flash[:success] = "Reservation made successfully!"
            redirect_to @reservation
          else
            render 'new'
          end
        else
          flash.now[:error] = "There is another reservation during the selected interval!"
          render 'new'
        end
      else
        if pickup >= dropoff
          flash.now[:error] = "Drop-off date must be after Pick-up date!"
          render 'new'
        else
          @reservation.pick_up_date = pickup
          @reservation.drop_off_date = dropoff 
          flash.now[:error] = "Vehicle is required!"
          render 'new'
        end
      end
    else
      #return render :text => "Param is #{pickup} #{dropoff}"
      flash.now[:error] = "Pick-up and drop-off dates are required!"
      render 'new'
    end
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def edit
    @reservation = Reservation.find(params[:id])
    from = @reservation.pick_up_date.in_time_zone(Time.zone)
    to = @reservation.drop_off_date.in_time_zone(Time.zone)
    @duration = time_diff_in_natural_language(from, to)
  end

  def update
    @reservation = Reservation.find(params[:id])
    from = @reservation.pick_up_date.in_time_zone(Time.zone)
    to = @reservation.drop_off_date.in_time_zone(Time.zone)
    @duration = time_diff_in_natural_language(from, to)
    #@resold = @reservation
    @vehicle = params[:vehicle][:id].blank? ? nil : Vehicle.find(params[:vehicle][:id])
    @client = params[:client][:id].blank? ? nil : Client.find(params[:client][:id])
    if !params[:pick_up_date].blank? && !params[:drop_off_date].blank?
      pickup = Time.strptime(params[:pick_up_date], '%d/%m/%Y %H:%M').in_time_zone(Time.zone)
      dropoff = Time.strptime(params[:drop_off_date], '%d/%m/%Y %H:%M').in_time_zone(Time.zone)
      @reservation.client = @client
      @reservation.vehicle = @vehicle
      @reservation.pick_up_date = pickup
      @reservation.drop_off_date = dropoff
      from = @reservation.pick_up_date.in_time_zone(Time.zone)
      to = @reservation.drop_off_date.in_time_zone(Time.zone)
      @duration = time_diff_in_natural_language(from, to)
      @reservation.reservation_code = params[:reservation_code]
      @reservation.status = ReservationStatus[params[:status][:id].to_i]
      if pickup < dropoff && !@vehicle.nil? 
        other = Reservation.where(:status => ['PENDING','CONFIRMED','RUNNING'], :vehicle_id => @vehicle.id).where('pick_up_date <= ? and drop_off_date >= ?', pickup, dropoff)
        if other.empty?
          if @reservation.save #@reservation.update_attributes({ reservation_code: params[:reservation_code], pick_up_date: pickup, drop_off_date: dropoff, status: ReservationStatus[params[:status][:id].to_i] })
            flash[:success] = "Reservation updated successfully!"
            redirect_to @reservation
          else
            render 'edit'
          end
        else
          flash.now[:error] = "There is another reservation during the selected interval!"
          render 'edit'
        end
      else
        if pickup >= dropoff
          flash.now[:error] = "Drop-off date must be after Pick-up date!"
          render 'edit'
        else
          flash.now[:error] = "Vehicle is required!"
          render 'edit'
        end
      end
    else
      #return render :text => "Param is #{pickup} #{dropoff}"
      flash.now[:error] = "Pick-up and drop-off dates are required!"
      render 'edit'
    end
  end




  #Ajax
  def show_duration
  	if !params[:from].blank? && !params[:to].blank?
  		from = Time.strptime(params[:from], '%d/%m/%Y %H:%M').in_time_zone(Time.zone)
  		to = Time.strptime(params[:to], '%d/%m/%Y %H:%M').in_time_zone(Time.zone)
  		duration_string = time_diff_in_natural_language(from, to)
  		respond_to do |format|
			 format.json { render :json =>  { duration: duration_string } }
		  end
	  else
		  respond_to do |format|
			 format.json { render :json =>  { duration: ' ' } }
		  end
	  end
  end

  #Ajax
  def book_vehicle
  	@vehicle = Vehicle.find(params[:vehicleid])
  	@client = Client.find(params[:client_id])
  	pickup = Time.strptime(params[:pickup], '%d/%m/%Y %H:%M').in_time_zone(Time.zone)
  	dropoff = Time.strptime(params[:dropoff], '%d/%m/%Y %H:%M').in_time_zone(Time.zone)
  	#return render :text => "Param is #{pickup} #{dropoff}"
  	@reservation = @vehicle.reservations.build(reservation_code: params[:rescode], pick_up_date: pickup, drop_off_date: dropoff)
	  @reservation.client = @client
  	if pickup < dropoff 
      other = Reservation.where(:status => ['PENDING','CONFIRMED','RUNNING'], :vehicle_id => @vehicle.id).where('pick_up_date <= ? and drop_off_date >= ?', pickup, dropoff)
		  if other.empty?
        respond_to do |format|
  		    if @reservation.save
  		  	   #c = Reservation.find(@reservation.reload.id).pick_up_date
  		  	   #return render :text => "Param is #{c}"
  	         format.json { render :json =>  { res: @reservation, errors: nil, success:true } }
  	      else
  	         @errors = []
  	         @reservation.errors.each do |key,value|
  	           @errors.push(value)
  	         end
  	         format.json { render :json =>  { res: @reservation, errors: @errors, success:false } }
  	      end
  	    end
      else
        #return render :text => "OTHER #{other.nil?} #{other.empty?}"
        respond_to do |format|  
          format.json { render :json =>  { res: @reservation, errors: ['Vehicle is booked for some days in this interval'], success:false } }
        end
      end
  	else
  		respond_to do |format|  
  	    format.json { render :json =>  { res: @reservation, errors: ['Pick-up date must be prior to drop-off date'], success:false } }
  	  end
  	end
  end

  #Ajax
  def check_booked_vehicles
    @vehicles = Vehicle.all
    @free =[]
    @not_free = []
    @vehicles.each do |v|
      @mod = Model.find(v.model_id)
      @mak = Make.find(@mod.make_id)
      @f = v.attributes
      @f[:model] = @mod
      @f[:make] = @mak
      @free.push(@f)
    end
    if !params[:from].blank? && !params[:to].blank?
      from = Time.strptime(params[:from], '%d/%m/%Y %H:%M').in_time_zone(Time.zone)
      to = Time.strptime(params[:to], '%d/%m/%Y %H:%M').in_time_zone(Time.zone)
      Reservation.where(:status => ['PENDING','CONFIRMED','RUNNING']).where(' (pick_up_date >= ? and pick_up_date < ?) or (drop_off_date > ? and drop_off_date <= ?)', from, to, from, to).each do |res|
        if params[:rescode].nil? || params[:rescode].blank? || ( !params[:rescode].nil? && !params[:rescode].blank? && res.reservation_code != params[:rescode])
          @mod = Model.find(res.vehicle.model_id)
          @mak = Make.find(@mod.make_id)
          @nf = res.vehicle.attributes
          @nf[:model] = @mod
          @nf[:make] = @mak
          @not_free.push(@nf) unless @not_free.include?(@nf)
        end
      end
      #return render :text => "asdas #{@not_free[0][:reg_no]}"
      @free -= @not_free    
    end
    respond_to do |format|
      format.json { render :json =>  { free_vehicles: @free } }
    end
  end

  #Ajax
  def check_booked_dates
  	@vehicle = Vehicle.find(params[:vehicleid])
  	#dat = Date.strptime(params[:dat], '%d/%m/%Y')
    dates = []
  	Reservation.where(:vehicle_id => @vehicle.id, :status => ['PENDING','CONFIRMED','RUNNING']).where('pick_up_date >= ? or drop_off_date >= ?', Time.zone.now, Time.zone.now).each do |res|
      if params[:rescode].nil? || params[:rescode].blank? || ( !params[:rescode].nil? && !params[:rescode].blank? && res.reservation_code != params[:rescode])
        dates += (res.pick_up_date.strftime('%Y-%m-%d')..res.drop_off_date.strftime('%Y-%m-%d')).to_a
      end
  	end
  	respond_to do |format|  
	   format.json { render :json =>  { bookedDates: dates, success: true } }
	  end
  end

end
