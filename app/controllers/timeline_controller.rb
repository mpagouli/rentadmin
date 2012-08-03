class TimelineController < ApplicationController

  before_filter :signed_in_user
  #before_filter :admin_user
  before_filter :select_operation_menu


  def timeline
  	@vehicles = Vehicle.all
  	@reservations = Reservation.all
  	#@timeline_base_date = Time.zone.now
  	@now_in_page = true
  end

  def timeline_ajax

  	@vehicles = Vehicle.all.sort {|x,y| x.id <=> y.id } 
  	vnames = []
  	@vehicles.each do |v|
  		vnames.push("#{v.model.make.make_name} #{v.model.model_name} (#{v.reg_no})")
  	end
  	
  	@reservations = Reservation.all
  	elements = []
  	@reservations.each do |r|
      #return render :text => "r code is #{r.reservation_code} and its status is #{ReservationStatus[r.status]}"
  		elem_html = "<div class='res_pickup_time'>#{r.pick_up_date.in_time_zone(Time.zone).strftime('%H:%M')}</div> <div class='res_customer'>#{r.client.name} #{r.client.surname}</div> <div class='res_dropoff_time'>#{r.drop_off_date.in_time_zone(Time.zone).strftime('%H:%M')}</div>"
      if r.duration < 24 * 60 * 60 #For reservations for less that 24 hours
        elem_html = '...'
      elsif r.duration >= ( 24 + 12 ) * 60 * 60 && r.duration <= 48 * 60 * 60 
      #For reservations of 36 to 48 hours
        elem_html ="<div class='res_pickup_time only'>#{r.pick_up_date.in_time_zone(Time.zone).strftime('%H:%M')}</div> <div class='res_dropoff_time only'>#{r.drop_off_date.in_time_zone(Time.zone).strftime('%H:%M')}</div>"
      end

      element = { :id => r.reservation_code,
  					:startDate => r.pick_up_date.in_time_zone(Time.zone).strftime('%d/%m/%Y %H:%M:%S'),
  					:endDate => r.drop_off_date.in_time_zone(Time.zone).strftime('%d/%m/%Y %H:%M:%S'),
  					:html => elem_html,
  					:index => "#{r.vehicle.model.make.make_name} #{r.vehicle.model.model_name} (#{r.vehicle.reg_no})", 
  				  :helper => { :status => "#{ReservationStatus[r.status]}" }
            }
  		elements.push(element)
  	end
  	
  	timeline_base_date = Time.zone.now

    respond_to do |format|
  	    format.json { render :json =>  { vnames: vnames, elements: elements, vehicles: @vehicles, res: @reservations, dat:timeline_base_date } }
    end
  end

end
