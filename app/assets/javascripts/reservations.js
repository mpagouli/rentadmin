$(document).ready(function() {

	var page_title = $(this).attr('title');

	//Index
	if( $(this).attr('title').indexOf('Reservations') !== -1 ){
		//$('.right-button form input').addClass('btn btn-large btn-primary');
		$('.right-button .button_to').attr('method','get');
	}

	if($(this).attr('title').indexOf('New Reservation') !== -1 || $(this).attr('title').indexOf('Edit Reservation') !== -1){ 
		
		$("input[name=sel_pickup]").hide();
		$("input[name=sel_dropoff]").hide();

		//Date pickers
		$("#drop_off_date, #pick_up_date").datetimepicker({ 
			dateFormat: "dd/mm/yy",  
        	beforeShow: function(a) {
        		var b = new Date();  
    			var c = new Date(b.getFullYear(), b.getMonth(), b.getDate());  
    			if (a.id == 'drop_off_date') {  
        			if ($('#pick_up_date').datepicker('getDate') != null) {  
            			c = $('#pick_up_date').datepicker('getDate');  
       				}  
    			}  
    			return {  
        			minDate: c  
    			}  
        	},
        	onSelect: function(dateText, inst) {
				var from, to, diff, mins, hours, days;
				$.ajax({
					url: '/show_duration',
					data: 'from='+$("input#pick_up_date").attr('value')+'&to='+$("input#drop_off_date").attr('value'),
					dataType: 'json',
					success: function(data) { 
				  		if(data.duration!=''){ 
				  			$("textarea#duration").attr('value',data.duration);
				  			if( $("input#pick_up_date").attr('value') !== '' && $("input#drop_off_date").attr('value') !== '' ){
								var freeVehicles, i, options; 
								if( $('#vehicle_id option:selected').attr('value') === '' ){ 
									//Limit available vehicles based on selected dates
									$.ajax({
										url: '/check_booked_vehicles',
										data: 'from='+$("input#pick_up_date").attr('value')+'&to='+$("input#drop_off_date").attr('value'),
										dataType: 'json',
										success: function(data) {  
											freeVehicles = data.free_vehicles; 
											options = "<option value=''></option>";
											for(i = 0; i < freeVehicles.length; i += 1){ 
											   	options += "<option value='"+freeVehicles[i].id+"'>" + freeVehicles[i].make.make_name + " " + freeVehicles[i].model.model_name + " (" + freeVehicles[i].reg_no +")</option>";
											}
											$('#vehicle_id').html(options);
								    		$('#vehicle_id').parent().removeClass("control-group warning");
								   			$('#vehicle_id').parent().addClass("control-group success");
								   			$('#vehicle_id').prev("label").html("Vehicles (" + freeVehicles.length + " available)");
								    		$('#vehicle_id').next("label").html("");	
										}
									});
								}
							}
				  		}
				  		else{
				  			$("textarea#duration").attr('value','There was a problem with defining the duration');
				  		}
					}
				});
			}
		});


		$('#vehicle_id').change(function(e){ 
			var veh, i, freeVehicles, options;
			veh = $('#vehicle_id').find(':selected'); 
			if( veh.attr('value') === '' ){
				$("#drop_off_date, #pick_up_date").datetimepicker("option", "beforeShowDay",
					function(date){ return [true,"",""]; });
				$("#drop_off_date, #pick_up_date").attr('value','');
				$('textarea#duration').attr('value','');
				$('#vehicle_id').parent().removeClass("control-group success");
				$('#vehicle_id').parent().addClass("control-group warning");
				$('#vehicle_id').next("label").html("Select dates to filter available vehicles list");
				$.ajax({
					url: '/check_booked_vehicles',
					data: 'from=&to=',
					dataType: 'json',
					success: function(data) {
						freeVehicles = data.free_vehicles; 
						options = "<option value=''></option>";
						for(i = 0; i < freeVehicles.length; i += 1){
							options += "<option value='"+freeVehicles[i].id+"'>" + freeVehicles[i].make.make_name + " " + freeVehicles[i].model.model_name + " (" + freeVehicles[i].reg_no +")</option>";
						}
						$('#vehicle_id').html(options);
					   	$('#vehicle_id').prev("label").html("Vehicles (" + freeVehicles.length + " available)");
					}
				});

			}
			else{
				if( $('#drop_off_date').attr('value') === '' && $('#pick_up_date').attr('value') === '' ){
					//Limit dates based on selected vehicle
					$.ajax({
						url: '/check_booked_dates',
						data: 'vehicleid='+veh.attr('value'),
						dataType: 'json',
						success: function(data) { 
							if(data.success){ 
							   var bookedDates = data.bookedDates; 
							    $("#drop_off_date, #pick_up_date").datetimepicker("option", "beforeShowDay",
									function(date){ 
										if(bookedDates.indexOf($.datepicker.formatDate('yy-mm-dd', date)) != -1)
											return [false,"bookedDate","test"]
										else
											return [true,"",""]
								});
								$('#vehicle_id').parent().removeClass("control-group warning");
								$('#vehicle_id').parent().addClass("control-group success");
								$('#vehicle_id').next("label").html("Available dates have been filtered according to the selected vehicle");
							}
						}
					});
				}
			}
		});
	}

	if($(this).attr('title').indexOf('Edit Reservation') !== -1){
		var veh, bookedDates, freeVehicles, i, options;
		//veh = $('#vehicle_id').find(':selected');
		if($("input[name=sel_pickup]").attr('value') !== ''){
			$("#pick_up_date").datetimepicker("setDate", $("input[name=sel_pickup]").attr('value'));
		}
		if($("input[name=sel_dropoff]").attr('value') !== ''){
			$("#drop_off_date").datepicker("setDate", $("input[name=sel_dropoff]").attr('value'));
		}

		//Limit available vehicles based on dates
		$.ajax({
			url: '/check_booked_vehicles',
			data: 'from='+$("input#pick_up_date").attr('value')+'&to='+$("input#drop_off_date").attr('value')+'&rescode='+$("input[name=reservation_code]").attr('value'),
			dataType: 'json',
			success: function(data) {  
				freeVehicles = data.free_vehicles; 
				options = "<option value=''></option>";
				for(i = 0; i < freeVehicles.length; i += 1){
					if(freeVehicles[i].id === parseInt($('#vehicle_id').find(':selected').attr('value')) ){
						options += "<option selected value='"+freeVehicles[i].id+"'>" + freeVehicles[i].make.make_name + " " + freeVehicles[i].model.model_name + " (" + freeVehicles[i].reg_no +")</option>";
					}
					else{
						options += "<option value='"+freeVehicles[i].id+"'>" + freeVehicles[i].make.make_name + " " + freeVehicles[i].model.model_name + " (" + freeVehicles[i].reg_no +")</option>";
					}	
				}
				$('#vehicle_id').html(options);
				$('#vehicle_id').parent().removeClass("control-group warning");
				$('#vehicle_id').parent().addClass("control-group success");
				$('#vehicle_id').prev("label").html("Vehicles (" + freeVehicles.length + " available)");

				//Limit dates based on vehicle
				$.ajax({
					url: '/check_booked_dates',
					data: 'vehicleid='+$('#vehicle_id').find(':selected').attr('value')+'&rescode='+$("input[name=reservation_code]").attr('value'),
					dataType: 'json',
					success: function(data) { 
						if(data.success){ 
							bookedDates = data.bookedDates; 
							$("#drop_off_date, #pick_up_date").datetimepicker("option", "beforeShowDay",
								function(date){ 
									if(bookedDates.indexOf($.datepicker.formatDate('yy-mm-dd', date)) != -1)
										return [false,"bookedDate","test"]
									else
										return [true,"",""]
							});
							$('#vehicle_id').parent().removeClass("control-group warning");
							$('#vehicle_id').parent().addClass("control-group success");
							$('#vehicle_id').next("label").html("Available dates and vehicles have been filtered");
						}
					}
				});	
			}
		});

		
				


	}


});
