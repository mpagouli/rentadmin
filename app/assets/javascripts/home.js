$(document).ready(function() {

  if( $(this).attr('title') === 'Open Fleet' ){
  
    if( $("#wheelmenu") !== undefined){

      // Find out the number of menu items enabled (differs according to admin or simple user)
      if( $("#wheelmenu").find("div#empty_right").attr('id') === undefined){
      	$("#wheelmenu").data('wheel_opts',2);
      }
      else{
    	$("#wheelmenu").data('wheel_opts',3);
      }

      $("#wheelmenu").data('clicks_num',0);
    
	  $("#wheelmenu").click(function(e){

	  	if ( $("#wheelmenu").hasClass("inProgress") === false ){ // In absence of wheel rotation
  
        // Wait 200ns for possible double clicks 
  	  	setTimeout(function () {
                dblclick = parseInt($("#wheelmenu").data('doubleclicked'), 10);
                if (dblclick > 0) {
                    $("#wheelmenu").data('doubleclicked', dblclick-1);
                } else { // Wheel Menu Clicked Once

                  $("#wheelmenu").addClass("inProgress");
                  // Repeat only values 1, 2, 3 (or 1,2) in the counter
                  var divider = $("#wheelmenu").data('wheel_opts') + 1;
  	  		      var count = ( $("#wheelmenu").data('clicks_num') + 1 ) % divider;
  	  		      count = (count === 0)? 1 : count;
  
  	  		      // Imitate Steering Wheel Movements
  	  		      switch(count){
  	  		     	case 1:
  	  		     		$("#wheelmenu").animate({rotate: '+=125deg'}, {queue: false, duration: 1000, complete: function() { $("#wheelmenu").removeClass("inProgress"); } });
  	  		     		break;
  	  		     	case 2:
  	  		     		if($("#wheelmenu").data('wheel_opts') === 2){
  	  		     			$("#wheelmenu").animate({rotate: '-=125deg'}, {queue: false, duration: 1000, complete: function() { $("#wheelmenu").removeClass("inProgress"); } });
  	  		     		}
  	  		     		else{
  	  		     			$("#wheelmenu").animate({rotate: '-=245deg'}, {queue: false, duration: 1000, complete: function() { $("#wheelmenu").removeClass("inProgress"); } });
  	  		     		}
  	  		     		break;
  	  		     	case 3:
  	  		     		$("#wheelmenu").animate({rotate: '+=120deg'}, {queue: false, duration: 1000, complete: function() { $("#wheelmenu").removeClass("inProgress"); } });
  	  		     		break;
  	  		     	default:
	  		     		$("#wheelmenu").animate({rotate: '+=0deg'});
		  	      }
  
  		  	      $("#wheelmenu").data('clicks_num', count);

                }
          }, 200);
		}
      })
	  .dblclick(function(e) { // Wheel Menu Double Clicked

	  	if ( $("#wheelmenu").hasClass("inProgress") === false ){ // In absence of wheel rotation

	        $("#wheelmenu").data('doubleclicked', 2);

	        // Find Menu Item Selected
		    var mselected = $("#wheelmenu").data('clicks_num');
		    
		    // Go To Appropriate Page
		    switch(mselected){
		    	case 1:
		    		//alert('Go to Dashboard');
		    		window.location.replace('/board');
		    		break;
		    	case 2:
		    		if($("#wheelmenu").data('wheel_opts') === 2){
	  	  		     	window.location.replace('/operation');
	  	  		    }
	  	  		    else{
		    			//alert('Go to Administration');
		    			window.location.replace('/admin');
		    		}
		    		break;
		    	case 3:
		    		//alert('Go to Operation');
		    		window.location.replace('/operation');
		    		break;
		    	default:
		    		//alert('Default: Go to Operation');
		    		window.location.replace('/operation');
		    }
     	}

      });

    }
  }

});