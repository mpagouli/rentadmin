class ReservationsController < ApplicationController
	include ActionView::Helpers::TextHelper

  before_filter :signed_in_user
  #before_filter :admin_user
  #before_filter :select_admin_menu

  def new
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
  def check_booked_dates
  	@vehicle = Vehicle.find(params[:vehicleid])
  	#dat = Date.strptime(params[:dat], '%d/%m/%Y')
    dates = []
  	Reservation.where(:vehicle_id => @vehicle.id, :status => ['PENDING','CONFIRMED','RUNNING']).where('pick_up_date >= ? or drop_off_date >= ?', Time.zone.now, Time.zone.now).each do |res|
  		dates += (res.pick_up_date.strftime('%Y-%m-%d')..res.drop_off_date.strftime('%Y-%m-%d')).to_a
  		#if dates.include?(dat.strftime('%Y-%m-%d'))
  			#respond_to do |format|  
	      		#format.json { render :json =>  { date_restricted: true } }
	    	#end
  		#end
  	end
  	respond_to do |format|  
	   format.json { render :json =>  { bookedDates: dates, success: true } }
	  end
  end

end
