$(document).ready(function() {

	//Dropdown
	/*if( $("a.dropdown-toggle:contains('Vehicles')") !== undefined ){
		$("a.dropdown-toggle:contains('Vehicles')").click(function(e){
			e.preventDefault();
			window.location.replace("/vehicles");
		});
	}*/

	//Index
	if( $(".vehicles") !== undefined ){
		$('.right-button form input').addClass('btn btn-large btn-primary');
		$('.right-button .button_to').attr('method','get');
	}

	//New - Edit
	if( $(".vehicle-form") !== undefined ){
		
		//New Make Dialog
        $("#make_new_dialog").dialog({ 
        	autoOpen:false,
        	height: 300,
			width: 450,
			modal: true,
			close: function() {
				$("input#make_name").attr('value','');
				$("textarea#description").attr('value','');
			}
        });
		$(".add_make").click(function(e){
			e.preventDefault();
			$("#make_new_dialog .center-button input").click(function(ee){
				$.ajax({
				  url: '/savemake',
				  data: 'make_name='+$("input#make_name").attr('value')+'&description='+$("textarea#description").attr('value'),
				  dataType: 'json',
				  success: function(data) { 
				  	if(data.success){
				  		options = $('#make_id').html();
				  		options += "<option value='"+data.make.id+"'>"+data.make.make_name+"</option>";
				  		options = $('#make_id').html(options);
				  		$("#make_new_dialog").dialog('close');
				  	}
				  	else{
				  		errorlist = '<ul>';
				  		for(i = 0; i < data.errors.length; i += 1){
				    		errorlist += "<li>* "+ data.errors[i] +"</li>";
				    	}
				    	errorlist += '</ul>';
				    	$("div#error_explanation").html(errorlist);
				    	$("input#make_name").attr('value',data.make.make_name);
				    	$("textarea#description").attr('value',data.make.description);
				  	}
				  }
				});
			});
			$("#make_new_dialog").dialog('open');
			$("#make_new_dialog").dialog( "option", "position","center" )
		});

		$("#make_id").change(function(e){
			var i, selected, options;
			selected = $(e.target).find(":selected");
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
			    $('#model_id').parent().addClass("control-group success");
			    $('#model_id').next("label").html(data.length+" models of make: "+selected.text());
			    $("input#make_id").attr('value',selected.val());
			  }
			});
		});

		//New Model Dialog
        $("#model_new_dialog").dialog({ 
        	autoOpen:false,
        	height: 300,
			width: 450,
			modal: true,
			close: function() {
				$("input#model_name").attr('value','');
				$("textarea#description").attr('value','');
			}
        });
		$(".add_model").click(function(e){
			e.preventDefault();
			$("#model_new_dialog .center-button input").click(function(ee){
				$.ajax({
				  url: '/savemodel',
				  data: 'make_id='+$("input#make_id").attr('value')+'&model_name='+$("input#make_name").attr('value')+'&description='+$("textarea#description").attr('value'),
				  dataType: 'json',
				  success: function(data) { 
				  	if(data.success){
				  		options = $('#model_id').html();
				  		options += "<option value='"+data.model.id+"'>"+data.model.model_name+"</option>";
				  		options = $('#model_id').html(options);
				  		$("#model_new_dialog").dialog('close');
				  	}
				  	else{
				  		errorlist = '<ul>';
				  		for(i = 0; i < data.errors.length; i += 1){
				    		errorlist += "<li>* "+ data.errors[i] +"</li>";
				    	}
				    	errorlist += '</ul>';
				    	$("div#error_explanation").html(errorlist);
				    	$("input#model_name").attr('value',data.model.model_name);
				    	$("textarea#description").attr('value',data.model.description);
				  	}
				  }
				});
			});
			$("#model_new_dialog").dialog('open');
			$("#model_new_dialog").dialog( "option", "position","center" )
		});
	}

});
