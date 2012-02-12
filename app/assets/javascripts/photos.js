$(document).ready(function() {
  
  if($("#photo_gallery").length > 0){
    
    //Load all the photos asynchronously on page load
    $.getJSON(window.location+".json", function(data){
      //Since the photos come in created_at ASC order,
      // we want to *append* them. So flip the array.
      $.each(data.reverse(), function(i, photo_data) {
        prependPhoto(photo_data)
      });
      
    });
    
  }
  
  //Always stick the newest photo at the front
  window.prependPhoto = function(data){
    var photo = photoToUsableJSON(data);
    var html = Mustache.to_html($("#gallery_photo_template").html(), photo);
    
    $("#photo_gallery").prepend(html);
    $(".photo:hidden").fadeIn();
    
    //If we're in live photo mode, update the photo
    if($("#fullscreen_photo:not(.dont_update)").length > 0){
      var img = $("#fullscreen_photo img");
      img.fadeOut();
      img.prop("src", photo["photo"]["base_src"]);
      showImageFullscreen(img);
    }
  }
  
  function photoToUsableJSON(data){
    return {
      id : data["id"],
      photo : {
        base_src: data["photo"]["url"],
        smaller_src: data["photo"]["polaroid"]["url"],
        alt: data["device_name"]
      }
    }
  }
  
  //The live photo cast
  $("#show_latest_photos").on("click", function(){
    prepareFullscreenImage($(".photo a:first").prop("href"));
  })
  
  //Show a photo fullscreen
  $("#photo_gallery").on("click", ".photo a", function(){
    prepareFullscreenImage($(this).prop("href"));
    //This isn't the live photo cast, though
    $("#fullscreen_photo").addClass("dont_update").css({"background-color": "rgba(0,0,0,0.75)"})
    return false;
  })
  
  function prepareFullscreenImage(image_src){
    $("body").append('<div id="fullscreen_photo"><img src="'+image_src+'" /></div>');
    
    var img = $("#fullscreen_photo img");
    var image_load_fired = false;
    img.load(function(){
      if(!image_load_fired){
        showImageFullscreen(img);
        image_load_fired = true;
      }
    });
    //For various reasons, .load mightn't fire. Have a timeout
    setTimeout(
      function(){
        if(!image_load_fired){
          showImageFullscreen(img);
          image_load_fired = true;
        }
      }, 3000)
    
    //Resize the photo if the window changes
    $(window).resize(function(){
      resizeAndPositionImage(img);
		});
		
		//Close fullscreen if you click it or press escape
		$("#fullscreen_photo").on("click", function(){closeFullscreen()});
		$(document).keyup(function(e) {
      if (e.keyCode == 27) { closeFullscreen(); }   // esc
    });
		
    return false;
  }
  
  function showImageFullscreen(img){
    resizeAndPositionImage(img);
    img.fadeIn();
  }
  
  function closeFullscreen(){
    $("#fullscreen_photo").fadeOut(300, function(){$(this).remove();});
  }
  
  function resizeAndPositionImage(img){
    var browserwidth = $(window).width();
    var browserheight = $(window).height();
    //Resize
    img.css(
      {
        "max-width": browserwidth, 
        "max-height": browserheight
      }).css(
      {
        "left": (browserwidth - img.width())/2,
        "top": (browserheight - img.height())/2
      });
  }
  
});