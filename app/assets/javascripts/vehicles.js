$(document).ready(function() {

	//Index
	if( $(".vehicles") !== undefined ){
		$('.right-button form input').addClass('btn btn-large btn-primary');
		$('.right-button .button_to').attr('method','get');
	}




	//New - Edit
	if( $(".vehicle-form") !== undefined ){

		$("#msg_dialog").dialog({ 
        	autoOpen:false,
        	height: 100,
			width: 250
        });
        $("#confirm_dialog").dialog({ 
        	autoOpen:false,
        	height: 150,
			width: 250
        });

		//MAKES
		$("input#makeid").hide();
		$("input#object_id").hide();
		$("#make_new_dialog").dialog({ 
        	autoOpen:false,
        	height: 375,
			width: 265,
			modal: true,
			close: function() {
				$("input#make_name").attr('value','');
				$("textarea#make_description").attr('value','');
				$("div#make_error_explanation").html('');
				$("input#makeid").attr('value','');
			}
        });
		//New Make Dialog..........................................................
		$(".add_make").click(function(e){
			e.preventDefault();
			$("#make_new_dialog .center-button input").click(function(ee){
				$.ajax({
				  url: '/savemake',
				  data: 'make_name='+$("input#make_name").attr('value')+'&make_description='+$("textarea#make_description").attr('value'),
				  dataType: 'json',
				  success: function(data) { 
				  	if(data.success){
				  		$('#make_id').find(':selected').removeAttr('selected');
				  		options = $('#make_id').html();
				  		options += "<option value='"+data.make.id+"' selected>"+data.make.make_name+"</option>";
				  		options = $('#make_id').html(options);
				  		$('#make_id').trigger('change');
				  		$("#make_new_dialog").dialog('close');
				  	}
				  	else{
				  		var errorlist = '<ul>';
				  		for(i = 0; i < data.errors.length; i += 1){
				    		errorlist += "<li>* "+ data.errors[i] +"</li>";
				    	}
				    	errorlist += '</ul>';
				    	$("div#make_error_explanation").html(errorlist);
				    	$("input#make_name").attr('value',data.make.make_name);
				    	$("textarea#make_description").attr('value',data.make.description);
				  	}
				  }
				});
			});
			$("input#makeid").attr('value',$("#make_id").find(":selected").attr('value'));
			$("#make_new_dialog .center-button input").attr('value','Insert Make');
			$("input#make_name").attr('value','');
			$("textarea#make_description").attr('value','');
			$("#make_new_dialog").dialog('option','title','New Make');
			$("#make_new_dialog").dialog('open');
			$("#make_new_dialog").dialog( "option", "position","bottom" )
		});
		//Edit Make Dialog.............................................................
		$(".edit_make").click(function(e){
			e.preventDefault();
			var selectedid = $("#make_id").find(":selected").attr('value');
			$.ajax({
				url: '/makeopen',
				data: 'makeid='+selectedid,
				dataType: 'json',
				success: function(data) { 
				 if(data.success){
				 	$("#make_new_dialog .center-button input").attr('value','Save changes');
				 	$("input#makeid").attr('value',data.make.id);
				  	$("input#make_name").attr('value',data.make.make_name);
					$("textarea#make_description").attr('value',data.make.description);
					$("#make_new_dialog").dialog('option','title','Edit Make');
					$("#make_new_dialog").dialog('open');
					$("#make_new_dialog").dialog( "option", "position","bottom" )
				  }
				  else{ 
				    $("div#msg_dialog").html(data.errors[0]);
				    $("div#msg_dialog").dialog('option','title','Failure');
				    $("#msg_dialog").dialog('open');
				  }
				 }
			});
			$("#make_new_dialog .center-button input").click(function(ee){
				ee.preventDefault();
				$.ajax({
				  url: '/makemodify',
				  data: 'makeid='+$("input#makeid").attr('value')+'&make_name='+$("input#make_name").attr('value')+'&make_description='+$("textarea#make_description").attr('value'),
				  dataType: 'json',
				  success: function(data) { 
				  	if(data.success){
				  		$('#make_id').find(':selected').removeAttr('selected');
				  		var opt = $('#make_id').find("option[value='"+$("input#makeid").attr('value')+"']").removeAttr('selected');
				  		opt.html(data.make.make_name);
				  		opt.attr('selected','selected');
				  		$('#make_id').trigger('change');
				  		$("#make_new_dialog").dialog('close');
				  	}
				  	else{
				  		var errorlist = '<ul>';
				  		for(i = 0; i < data.errors.length; i += 1){
				    		errorlist += "<li>* "+ data.errors[i] +"</li>";
				    	}
				    	errorlist += '</ul>';
				    	$("div#make_error_explanation").html(errorlist);
				    	$("input#make_name").attr('value',data.make.make_name);
				    	$("textarea#make_description").attr('value',data.make.description);
				  	}
				  }
				});
			});
		});
		//Delete Make Dialog.............................................................
		$(".delete_make").click(function(e){
			e.preventDefault();
			$("#confirm_dialog .center-button button").first().unbind('click');
			$("#confirm_dialog .center-button button").last().unbind('click');
			var selectedid = $("#make_id").find(":selected").attr('value');
			$.ajax({
				url: '/makeopen',
				data: 'makeid='+selectedid,
				dataType: 'json',
				success: function(data) { 
				 if(data.success){
				 	$("input#object_id").attr('value',data.make.id);
				 	$("div#confirm_dialog").dialog('open');
				  }
				  else{ 
				    $("div#msg_dialog").html(data.errors[0]);
				    $("div#msg_dialog").dialog('option','title','Failure');
				    $("#msg_dialog").dialog('open');
				  }
				 }
			});
			$("#confirm_dialog .center-button button").first().click(function(ee){
				$("#confirm_dialog").dialog('close');
				$.ajax({
				  url: '/dropmake',
				  data: 'makeid='+$("input#object_id").attr('value'),
				  dataType: 'json',
				  success: function(data) { 
				  	if(data.success){ 
				  		$("div#msg_dialog").html('Successfully deleted make');
				    	$("div#msg_dialog").dialog('option','title','Success');
				    	$("#msg_dialog").dialog('open');
				  		$('#make_id').find(':selected').remove();
				  		$('#make_id').find("option[value='']").attr('selected');
				  		$('#make_id').trigger('change');
				  	}
				  	else{ 
				    	$("div#msg_dialog").html(data.errors[0]);
				    	$("div#msg_dialog").dialog('option','title','Failure');
				    	$("#msg_dialog").dialog('open');
				  	}
				  }
				});
			});
			$("#confirm_dialog .center-button button").last().click(function(ee){
				$("#confirm_dialog").dialog('close');
			});
		});

		//MAKE SELECT LIST
		$("#make_id").change(function(e){
			var i, selected, options;
			selected = $(e.target).find(":selected");
			if (selected.val()!=""){
				$.ajax({
				  url: '/filter_models',
				  data: 'make_id='+selected.val(),
				  dataType: 'json',
				  success: function(data) {
				    options = "<option value=''></option>";
				    for(i = 0; i < data.length; i += 1){
				    	options += "<option value='"+data[i].id+"'>"+data[i].model_name+"</option>";
				    }
				    $('#model_id').html(options);
				    $('#model_id').prev("label").children("a").show();
				    $('#model_id').parent().removeClass("control-group warning");
				    $('#model_id').parent().addClass("control-group success");
				    $('#model_id').next("label").html(data.length+" models of make: "+selected.text());
				  }
				});
			}
			else{
				$('#model_id').html('');
				$('#model_id').prev("label").children("a").hide();
				$('#model_id').parent().removeClass("control-group success");
				$('#model_id').parent().addClass("control-group warning");
				$('#model_id').next("label").html('Select make to filter models list');
			}
		});

		//MODELS
		//New Model Dialog............................................................................
		$("input#modelid").hide();
		$("input#makeid").hide();
		$("input#objectid").hide();
        $("#model_new_dialog").dialog({ 
        	autoOpen:false,
        	height: 385,
			width: 265,
			modal: true,
			close: function() {
				$("input#model_name").attr('value','');
				$("textarea#model_description").attr('value','');
				$("div#model_error_explanation").html('');
				$("input#makeid").attr('value','');
				$("input#modelid").attr('value','');
				$("input#objectid").attr('value','')
			}
        });
		$(".add_model").click(function(e){
			e.preventDefault();
			$("#model_new_dialog .center-button input").click(function(ee){
				ee.preventDefault();
				$.ajax({
				  url: '/savemodel',
				  data: 'makeid='+$("input#makeid").attr('value')+'&model_name='+$("input#model_name").attr('value')+'&model_description='+$("textarea#model_description").attr('value'),
				  dataType: 'json',
				  success: function(data) { 
				  	if(data.success){
				  		$('#model_id').find(':selected').removeAttr('selected');
				  		options = $('#model_id').html();
				  		options += "<option value='"+data.model.id+"' selected>"+data.model.model_name+"</option>";
				  		options = $('#model_id').html(options);
				  		$('#model_id').next("label").html("Added new model of selected make");
				  		$("#model_new_dialog").dialog('close');
				  	}
				  	else{
				  		var errorlist = '<ul>';
				  		for(i = 0; i < data.errors.length; i += 1){
				    		errorlist += "<li>* "+ data.errors[i] +"</li>";
				    	}
				    	errorlist += '</ul>';
				    	$("div#model_error_explanation").html(errorlist);
				    	$("input#model_name").attr('value',data.model.model_name);
				    	$("textarea#model_description").attr('value',data.model.description);
				  	}
				  }
				});
			});
			$("input#makeid").attr('value',$("#make_id").find(":selected").attr('value'));
			$("#model_new_dialog .center-button input").attr('value','Insert Model');
			$("input#modelid").attr('value','');
			$("input#model_name").attr('value','');
			$("textarea#model_description").attr('value','');
			$("#model_new_dialog").dialog('option','title','New Model');
			$("#model_new_dialog").dialog('open');
			$("#model_new_dialog").dialog( "option", "position","bottom" )
		});
		
		//Edit Model Dialog.............................................................
		$(".edit_model").click(function(e){
			e.preventDefault();
			var selectedid = $("#model_id").find(":selected").attr('value');
			$.ajax({
				url: '/modelopen',
				data: 'modelid='+selectedid,
				dataType: 'json',
				success: function(data) { 
				 if(data.success){
				 	$("#model_new_dialog .center-button input").attr('value','Save changes');
				 	$("input#modelid").attr('value',data.model.id);
				  	$("input#model_name").attr('value',data.model.model_name);
					$("textarea#model_description").attr('value',data.model.description);
					$("#model_new_dialog").dialog('option','title','Edit Model');
					$("#model_new_dialog").dialog('open');
					$("#model_new_dialog").dialog( 'option', 'position','bottom');
				  }
				  else{
				    $("div#msg_dialog").html(data.errors[0]);
				    $("div#msg_dialog").dialog('option','title','Failure');
				    $("#msg_dialog").dialog('open');
				  }
				 }
			});
			$("#model_new_dialog .center-button input").click(function(ee){
				ee.preventDefault();
				$.ajax({
				  url: '/modelmodify',
				  data: 'modelid='+$("input#modelid").attr('value')+'&model_name='+$("input#model_name").attr('value')+'&model_description='+$("textarea#model_description").attr('value'),
				  dataType: 'json',
				  success: function(data) { 
				  	if(data.success){
				  		$('#model_id').find(':selected').removeAttr('selected');
				  		var opt = $('#model_id').find("option[value='"+$("input#modelid").attr('value')+"']");
				  		opt.html(data.model.model_name);
				  		opt.attr('selected','selected');
				  		$('#model_id').trigger('change');
				  		$('#model_id').next("label").html("Modified selected model");
				  		$("#model_new_dialog").dialog('close');
				  	}
				  	else{
				  		var errorlist = '<ul>';
				  		for(i = 0; i < data.errors.length; i += 1){
				    		errorlist += "<li>* "+ data.errors[i] +"</li>";
				    	}
				    	errorlist += '</ul>';
				    	$("div#model_error_explanation").html(errorlist);
				    	$("input#model_name").attr('value',data.model.model_name);
				    	$("textarea#model_description").attr('value',data.model.description);
				  	}
				  }
				});
			});
		});
		//Delete Model Dialog.............................................................
		$(".delete_model").click(function(e){
			e.preventDefault();
			$("#confirm_dialog .center-button button").first().unbind('click');
			$("#confirm_dialog .center-button button").last().unbind('click');
			var selectedid = $("#model_id").find(":selected").attr('value');
			$.ajax({
				url: '/modelopen',
				data: 'modelid='+selectedid,
				dataType: 'json',
				success: function(data) { 
				 if(data.success){
				 	$("input#object_id").attr('value',data.model.id);
				 	$("div#confirm_dialog").dialog('open');
				  }
				  else{ 
				    $("div#msg_dialog").html(data.errors[0]);
				    $("div#msg_dialog").dialog('option','title','Failure');
				    $("#msg_dialog").dialog('open');
				  }
				 }
			});
			$("#confirm_dialog .center-button button").first().click(function(ee){
				$("#confirm_dialog").dialog('close');
				$.ajax({
				  url: '/dropmodel',
				  data: 'modelid='+$("input#object_id").attr('value'),
				  dataType: 'json',
				  success: function(data) { 
				  	if(data.success){ 
				  		$("div#msg_dialog").html('Successfully deleted model');
				    	$("div#msg_dialog").dialog('option','title','Success');
				    	$("#msg_dialog").dialog('open');
				  		$('#model_id').find(':selected').remove();
				  		$('#modele_id').find("option[value='']").attr('selected');
				  		$('#model_id').trigger('change');
				  		$('#model_id').next("label").html("Deleted model of selected make");
				  	}
				  	else{
				    	$("div#msg_dialog").html(data.errors[0]);
				    	$("div#msg_dialog").dialog('option','title','Failure');
				    	$("#msg_dialog").dialog('open');
				  	}
				  }
				});
			});
			$("#confirm_dialog .center-button button").last().click(function(ee){
				$("#confirm_dialog").dialog('close');
			});
		});
	}


	//Book Vehicle
	if( $("#book_vehicle") !== undefined && $("input#vehicleid").attr('value') !== undefined){ 
		
		//Date pickers
		$.ajax({
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
		});
		
		/*function befShow(date){
			alert('xox')
				$.ajax({
					url: '/check_drop_date',
					data: 'dat='+$.datepicker.formatDate('dd/mm/yy', date)+'&vehicleid='+$("input#vehicleid").attr('value'),
					dataType: 'json',
					success: function(data) { 
					  if(data.date_restricted){ 
					  	return [false, ""]
					  }
					  else{
					  	return [true, ""]
					  }
					}
				});
		}*/

		

		$("input#vehicleid").hide();
        $("#book_vehicle_dialog").dialog({ 
        	autoOpen:false,
        	height: 385,
			width: 900,
			modal: true,
			close: function() {
				$("select#client_id option:selected").removeAttr("selected");
				$("select#status_id option:selected").removeAttr("selected");
				$("select#status_id option[value='1']").attr('selected','selected');
				$("input#pick_up_date").datepicker('setDate', null);
				$("input#drop_off_date").datepicker('setDate', null);
				$("textarea#duration").attr('value','');
				$("input#reservation_code").attr('value','');
				$("div#res_error_explanation").html('');
			}
        });
		$("#book_vehicle").click(function(e){ 
			e.preventDefault();
			$("#book_vehicle_dialog .center-button input").click(function(ee){
				ee.preventDefault();
				var datastring = 'client_id='+$("select#client_id").attr('value')+
								 '&vehicleid='+$("input#vehicleid").attr('value')+
								 '&pickup='+$("input#pick_up_date").attr('value')+
								 '&dropoff='+$("input#drop_off_date").attr('value')+
								 '&rescode='+$("input#reservation_code").attr('value');
				$.ajax({
				  url: '/book_vehicle',
				  data: datastring,
				  dataType: 'json',
				  success: function(data) { 
				  	if(data.success){
				  		window.location.replace('/vehicles/'+$("input#vehicleid").attr('value'));
				  		$("#book_vehicle_dialog").dialog('close');
				  	}
				  	else{
				  		var errorlist = '<ul>';
				  		for(i = 0; i < data.errors.length; i += 1){
				    		errorlist += "<li>* "+ data.errors[i] +"</li>";
				    	}
				    	errorlist += '</ul>';
				    	$("div#res_error_explanation").html(errorlist);
				    	//$("input#model_name").attr('value',data.model.model_name);
				    	//$("textarea#model_description").attr('value',data.model.description);
				  	}
				  }
				});
			});
			//$("input#vehicleid").attr('value',$("#sel_vehicle_id").attr('value'));
			$("#book_vehicle_dialog .center-button input").attr('value','Make Reservation');
			//$("input#resid").attr('value','');
			//$("input#model_name").attr('value','');
			//$("textarea#model_description").attr('value','');
			$("#book_vehicle_dialog").dialog('option','title','New Reservation');
			$("#book_vehicle_dialog").dialog('open');
			$("#book_vehicle_dialog").dialog( "option", "position","bottom" );
		});

		


	}




	//Dropdown
	/*if( $("a.dropdown-toggle:contains('Vehicles')") !== undefined ){
		$("a.dropdown-toggle:contains('Vehicles')").click(function(e){
			e.preventDefault();
			window.location.replace("/vehicles");
		});
	}*/

});
