$(document).ready(function() {

  if( $("#wheelmenu") !== 'undefined'){

    $("#wheelmenu").data('clicks_num',0);

	$("#wheelmenu").click(function(e){

        // Wait 200ns for possible double clicks 
		setTimeout(function () {
            dblclick = parseInt($("#wheelmenu").data('doubleclicked'), 10);
            if (dblclick > 0) {
                $("#wheelmenu").data('doubleclicked', dblclick-1);
            } else { // Wheel Menu Clicked Once
                
                // Repeat values 1, 2, 3 only for counter
			    var count = ( $("#wheelmenu").data('clicks_num') + 1 ) % 4;
			    count = (count === 0)? 1 : count;

			    // Imitate Steering Wheel Movements
			     switch(count){
			     	case 1:
			     		$("#wheelmenu").animate({rotate: '+=125deg'}, {queue: false, duration: 1000});
			     		break;
			     	case 2:
			     		$("#wheelmenu").animate({rotate: '-=245deg'}, {queue: false, duration: 1000});
			     		break;
			     	case 3:
			     		$("#wheelmenu").animate({rotate: '+=120deg'}, {queue: false, duration: 1000});
			     		break;
			     	default:
			     		$("#wheelmenu").animate({rotate: '+=0deg'});
			     }

			    $("#wheelmenu").data('clicks_num', count);
            }
        }, 200);
    })
	.dblclick(function(e) { // Wheel Menu Double Clicked

        $("#wheelmenu").data('doubleclicked', 2);

        // Find Menu Item Selected
	    var mselected = $("#wheelmenu").data('clicks_num');
	    
	    // Go To Appropriate Page
	    switch(mselected){
	    	case 1:
	    		alert('Go to Dashboard');
	    		break;
	    	case 2:
	    		alert('Go to Administration');
	    		break;
	    	case 3:
	    		alert('Go to Operation');
	    		break;
	    	default:
	    		alert('Default: Go to Operation');
	    }

    });

  }

});