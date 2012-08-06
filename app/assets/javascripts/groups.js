$(document).ready(function() {

	//var page_title = $(this).attr('title');

	if( $('div#model_new_dialog').dialog("isOpen")){
	//if( $(this).attr('title').indexOf('New Vehicle') !== -1 || $(this).attr('title').indexOf('Edit Vehicle') !== -1){

		//GROUPS
		$("div#group_new_dialog input#groupid").hide();
		$("input#object_id").hide();
		$("#group_new_dialog").dialog({ 
        	autoOpen:false,
        	height: 375,
			width: 265,
			modal: true,
			close: function() {
				$("input#group_name").attr('value','');
				$("textarea#group_description").attr('value','');
				$("div#group_error_explanation").html('');
				$('#group_id').find(':selected').removeAttr('selected');
				//var opt = $('#group_id').find("option[value='']");
				//opt.attr('selected','selected');
			}
        });
		//New Group Dialog..........................................................
		$(".add_group").click(function(e){
			e.preventDefault();
			$("#group_new_dialog .center-button button").click(function(ee){
				$.ajax({
				  url: '/savegroup',
				  data: 'group_name='+$("input#group_name").attr('value')+'&group_description='+$("textarea#group_description").attr('value'),
				  dataType: 'json',
				  success: function(data) { 
				  	if(data.success){
				  		$('#group_id').find(':selected').removeAttr('selected');
				  		options = $('#group_id').html();
				  		options += "<option value='"+data.group.id+"' selected>"+data.group.group_name+"</option>";
				  		options = $('#group_id').html(options);
				  		$('#group_id').trigger('change');
				  		$("#group_new_dialog").dialog('close');
				  	}
				  	else{
				  		var errorlist = '<ul>';
				  		for(i = 0; i < data.errors.length; i += 1){
				    		errorlist += "<li>* "+ data.errors[i] +"</li>";
				    	}
				    	errorlist += '</ul>';
				    	$("div#group_error_explanation").html(errorlist);
				    	$("input#group_name").attr('value',data.group.group_name);
				    	$("textarea#group_description").attr('value',data.group.description);
				  	}
				  }
				});
			});
			document.getElementById('group_id').selectedIndex = -1;
			//$("input#groupid").attr('value',$("#group_id").find(":selected").attr('value'));
			$("#group_new_dialog .center-button button").html('Insert Group');
			$("input#group_name").attr('value','');
			$("textarea#group_description").attr('value','');
			$("#group_new_dialog").dialog('option','title','New Group');
			$("#group_new_dialog").dialog('open');
			$("#group_new_dialog").dialog( "option", "position","bottom" )
		});
		//Edit Group Dialog.............................................................
		$(".edit_group").click(function(e){
			e.preventDefault();
			var selectedid = $("#group_id").find(":selected").attr('value');
			$.ajax({
				url: '/groupopen',
				data: 'groupid='+selectedid,
				dataType: 'json',
				success: function(data) { 
				 if(data.success){
				 	$("#group_new_dialog .center-button button").html('Save changes');
				 	$("input#groupid").attr('value',data.group.id);
				  	$("input#group_name").attr('value',data.group.group_name);
					$("textarea#group_description").attr('value',data.group.description);
					$("#group_new_dialog").dialog('option','title','Edit Group');
					$("#group_new_dialog").dialog('open');
					$("#group_new_dialog").dialog( "option", "position","bottom" )
				  }
				  else{ 
				    $("div#msg_dialog").html(data.errors[0]);
				    $("div#msg_dialog").dialog('option','title','Failure');
				    $("#msg_dialog").dialog('open');
				  }
				 }
			});
			$("#group_new_dialog .center-button button").click(function(ee){
				ee.preventDefault();
				$.ajax({
				  url: '/groupmodify',
				  data: 'groupid='+$("input#groupid").attr('value')+'&group_name='+$("input#group_name").attr('value')+'&group_description='+$("textarea#group_description").attr('value'),
				  dataType: 'json',
				  success: function(data) { 
				  	if(data.success){
				  		/*$('#group_id').find(':selected').removeAttr('selected');
				  		var opt = $('#group_id').find("option[value='"+$("input#groupid").attr('value')+"']").removeAttr('selected');
				  		opt.html(data.group.group_name);
				  		opt.attr('selected','selected');
				  		$('#group_id').trigger('change');*/
				  		$("#group_new_dialog").dialog('close');
				  	}
				  	else{
				  		var errorlist = '<ul>';
				  		for(i = 0; i < data.errors.length; i += 1){
				    		errorlist += "<li>* "+ data.errors[i] +"</li>";
				    	}
				    	errorlist += '</ul>';
				    	$("div#group_error_explanation").html(errorlist);
				    	$("input#group_name").attr('value',data.group.group_name);
				    	$("textarea#group_description").attr('value',data.group.description);
				  	}
				  }
				});
			});
		});
		//Delete Make Dialog.............................................................
		$(".delete_group").click(function(e){
			e.preventDefault();
			$("#confirm_dialog .center-button button").first().unbind('click');
			$("#confirm_dialog .center-button button").last().unbind('click');
			var selectedid = $("#group_id").find(":selected").attr('value');
			$.ajax({
				url: '/groupopen',
				data: 'groupid='+selectedid,
				dataType: 'json',
				success: function(data) { 
				 if(data.success){
				 	$("input#object_id").attr('value',data.group.id);
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
				  url: '/dropgroup',
				  data: 'groupid='+$("input#object_id").attr('value'),
				  dataType: 'json',
				  success: function(data) { 
				  	if(data.success){ 
				  		$("div#msg_dialog").html('Successfully deleted group');
				    	$("div#msg_dialog").dialog('option','title','Success');
				    	$("#msg_dialog").dialog('open');
				  		$('#group_id').find(':selected').remove();
				  		$('#group_id').find("option[value='']").attr('selected');
				  		$('#group_id').trigger('change');
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

});