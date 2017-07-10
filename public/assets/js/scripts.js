$.fn.scrollTo = function (speed) {
    if (typeof(speed) === 'undefined')
        speed = 1000;

    $('html, body').animate({
        scrollTop: parseInt($(this).offset().top)
    }, speed);
};

jQuery(document).ready(function() {
	
	/*
	    Navigation
	*/
	$('a.scroll-link').on('click', function(e) {
		e.preventDefault();
		$($(this).attr('href')).scrollTo(700);
	});	
	
    /*
        Background slideshow
    */
    $('.top-content').backstretch("assets/img/backgrounds/1d.jpg");
    $('.how-it-works-container').backstretch("assets/img/backgrounds/1d.jpg");
    $('.call-to-action-container').backstretch("assets/img/backgrounds/1d.jpg");
    
    $('#top-navbar-1').on('shown.bs.collapse', function(){
    	$('.top-content').backstretch("resize");
    });
    $('#top-navbar-1').on('hidden.bs.collapse', function(){
    	$('.top-content').backstretch("resize");
    });
    
    /*
        Wow
    new WOW().init();
    
	/*
	    Modals
	*/
	$('.launch-modal').on('click', function(e){
		e.preventDefault();
		$( '#' + $(this).data('modal-id') ).modal();
	});
	
});


jQuery(window).load(function() {
	
	/*
		Loader
	*/
	$(".loader-img").fadeOut();
	$(".loader").delay(1000).fadeOut("slow");
	
	/*
		Hidden images
	*/
	$(".modal-body img, .testimonial-image img").attr("style", "width: auto !important; height: auto !important;");
	
});

