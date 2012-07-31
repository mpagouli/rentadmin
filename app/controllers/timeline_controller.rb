class TimelineController < ApplicationController

  before_filter :signed_in_user
  before_filter :admin_user
  #before_filter :select_admin_menu


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
  		element = { :id => r.reservation_code,
  					:startDate => r.pick_up_date.in_time_zone(Time.zone).strftime('%d/%m/%Y %H:%M:%S'),
  					:endDate => r.drop_off_date.in_time_zone(Time.zone).strftime('%d/%m/%Y %H:%M:%S'),
  					:label => "#{r.client.name} #{r.client.surname}",
  					:index => "#{r.vehicle.model.make.make_name} #{r.vehicle.model.model_name} (#{r.vehicle.reg_no})" 
  				  }
  		elements.push(element)
  	end
  	
  	timeline_base_date = Time.zone.now

    respond_to do |format|
  	    format.json { render :json =>  { vnames: vnames, elements: elements, vehicles: @vehicles, res: @reservations, dat:timeline_base_date } }
    end
  end

end
