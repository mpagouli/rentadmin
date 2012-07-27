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
		//$("#model_id").html("<option value=''></option>");
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
			    $('#model_id').parent().addClass("control-group success");
			    $('#model_id').next("label").html(data.length+" models of make: "+selected.text());
			  }
			});
		});
	}

});
