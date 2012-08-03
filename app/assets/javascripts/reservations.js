$(document).ready(function() {

	var page_title = $(this).attr('title');

	if($(this).attr('title').indexOf('New Reservation') !== -1){ 
		
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
				  		}
				  		else{
				  			$("textarea#duration").attr('value','There was a problem with defining the duration');
				  		}
					}
				});
			},
			/*beforeShowDay: function(date){ 
				if(bookedDates.indexOf($.datepicker.formatDate('yy-mm-dd', date)) != -1)
					return [false,"bookedDate","test"]
				else
					return [true,"",""]
			}*/	
		});



		/*$.ajax({
			url: '/check_booked_dates',
			data: 'vehicleid='+$("input#vehicleid").attr('value'),
			dataType: 'json',
			success: function(data) { 
				if(data.success){ 
				   var bookedDates = data.bookedDates;

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
							  		}
							  		else{
							  			$("textarea#duration").attr('value','There was a problem with defining the duration');
							  		}
								}
							});
						},
						beforeShowDay: function(date){ 
							if(bookedDates.indexOf($.datepicker.formatDate('yy-mm-dd', date)) != -1)
								return [false,"bookedDate","test"]
							else
								return [true,"",""]
						}	
					});
				}
			}
		});*/
		

	}


});
