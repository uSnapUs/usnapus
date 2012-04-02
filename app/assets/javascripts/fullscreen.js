// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require klass.min
//= require jquery
//= require code.photoswipe.jquery-3.0.4
//= require photos

(function(window, $, PhotoSwipe){
	
	$(document).ready(function(){
		
		//Load all the photos asynchronously on page load
		var event_url = $("#gallery").attr("data-event-url");
    $.getJSON(event_url, function(data){
      
      var photos = [];
      
      //Since the photos come in created_at ASC order,
      // we want to *append* them. So flip the array.
      $.each(data.reverse(), function(i, data) {
        photos.push({
          original_src: data["photo"]["url"],
          xga_src: data["photo"]["xga"]["url"],
          alt: data["device_name"]
        });
      });
      
      var image_type = imageTypeForScreen()+"_src";
      
      var options = {
        getImageSource: function(obj){
          return obj[image_type];
        },
        getImageCaption: function(obj){
          return obj["alt"];
        },
        autoStartSlideshow: true,
        loop: true,
        slideshowDelay: 5000,
        allowUserZoom: false
      }

      if(photos.length){
        instance = PhotoSwipe.attach(photos, options);
    		instance.show(0);
        // onBeforeHide
  			instance.addEventHandler(PhotoSwipe.EventTypes.onBeforeHide, function(e){
  				window.location = event_url.replace(".json", "");
  			});
      }else{
        $("#no_photos").fadeIn();
      }
  		
    });
	
	});
	
	
}(window, window.jQuery, window.Code.PhotoSwipe));