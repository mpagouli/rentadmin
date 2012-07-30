class ReservationsController < ApplicationController
	include ActionView::Helpers::TextHelper

  def new
  end

  #Ajax
  def show_duration
  	if !params[:from].blank? && !params[:to].blank?
  		from = Date.strptime(params[:from], '%d/%m/%Y')
  		to = Date.strptime(params[:to], '%d/%m/%Y')
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
  	pickup = DateTime.strptime(params[:pickup], '%d/%m/%Y')
  	dropoff = DateTime.strptime(params[:dropoff], '%d/%m/%Y')
  	#return render :text => "Param is #{pickup} #{dropoff}"
  	@reservation = @vehicle.reservations.build(reservation_code: params[:rescode], pick_up_date: pickup, drop_off_date: dropoff)
	@reservation.client = @client
  	if pickup < dropoff 	
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
		respond_to do |format|  
	      format.json { render :json =>  { res: @reservation, errors: ['Pick-up date must be prior to drop-off date'], success:false } }
	    end
	end
  end


  #Ajax
  def check_drop_date
  	@vehicle = Vehicle.find(params[:vehicleid])
  	dat = Date.strptime(params[:dat], '%d/%m/%Y')
  	Reservation.where('vehicle_id=?',@vehicle.id).each do |res|
  		dates = (res.pick_up_date.strftime('%Y-%m-%d')..res.drop_off_date.strftime('%Y-%m-%d')).to_a
  		if dates.include?(dat.strftime('%Y-%m-%d'))
  			respond_to do |format|  
	      		format.json { render :json =>  { date_restricted: true } }
	    	end
  		end
  	end
  	respond_to do |format|  
	  format.json { render :json =>  { date_restricted: false } }
	end
  end

end
