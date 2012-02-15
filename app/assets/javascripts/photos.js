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
      prepareFullscreenImage(photo["photo"]["base_src"]);
    }
  }
  
  function photoToUsableJSON(data){
    return {
      id : data["id"],
      photo : {
        base_src: data["photo"]["url"],
        xga_src: data["photo"]["xga"]["url"],
        thumbnail_src: data["photo"]["thumbnail"]["url"],
        alt: data["device_name"]
      }
    }
  }
  
  //The live photo cast
  $("#show_latest_photos").on("click", function(){
    prepareFullscreenImage($(".photo a:first img"));
  })
  
  //Show a photo fullscreen
  $("#photo_gallery").on("click", ".photo a", function(){
    prepareFullscreenImage($(this).find("img"));
    //This isn't the live photo cast, though
    $("#fullscreen_photo").addClass("dont_update").css({"background-color": "rgba(0,0,0,0.75)"})
    return false;
  })
  
  function prepareFullscreenImage(image_el){
    
    var image_src = null;
    if($(window).width() <= 1024){
      image_src = image_el.attr("data-xga-src");
    }else{
      image_src = image_el.attr("data-original-src");
    }
    
    if($('#fullscreen_photo').length > 0){
      //There's already a photo on display
    }else{
      $("body").append('<div id="fullscreen_photo"></div>'); 
    }
    
    var fullscreen_photo_div = $("#fullscreen_photo");
    fullscreen_photo_div.append('<img src="'+image_src+'" class="new" />')
    fullscreen_photo_div.css({height: Math.max($("html").height(), $(window).outerHeight())})
    
    var img = $("#fullscreen_photo img.new");
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
    $("#fullscreen_photo img:not(.new)").fadeOut(500, function(){
      $(this).remove();
    })
    $("#fullscreen_photo img.new").fadeIn(500, function(){
      $(this).removeClass("new")
    })
  }
  
  function closeFullscreen(){
    $("#fullscreen_photo").fadeOut(1000, function(){$(this).remove();});
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
        "top": ((browserheight - img.height())/2)+$(window).scrollTop()
      });
  }
  
});