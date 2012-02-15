(function(window, $, PhotoSwipe){
	
	$(document).ready(function(){
		
		//Load all the photos asynchronously on page load
		var event_url = $("#gallery").attr("data-event-url");
    $.getJSON(event_url, function(data){
      
      var photos = []
      
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

  		instance = PhotoSwipe.attach(photos, options);
  		instance.show(0);
      // onBeforeHide
			instance.addEventHandler(PhotoSwipe.EventTypes.onBeforeHide, function(e){
				window.location = event_url;
			});
    });
	
	});
	
	
}(window, window.jQuery, window.Code.PhotoSwipe));