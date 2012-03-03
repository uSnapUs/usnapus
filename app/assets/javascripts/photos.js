$(document).ready(function() {
  
  window.imageTypeForScreen = function(){
      if($(window).width() <= 1024){
        return "xga";
      }
      else{
        return "xga"; //Hack for webstock
      }
    }
  
  function photoToUsableJSON(data){
    return {
      id : data["id"],
      photo : {
        base_src: data["photo"]["url"],
        original_src: data["photo"]["url"],
        xga_src: data["photo"]["xga"]["url"],
        thumbnail_src: data["photo"]["thumbnail"]["url"],
        alt: data["device_name"]
      }
    };
  }
  
  //Always stick the newest photo at the front
  window.prependPhoto = function(data){
    var photo = photoToUsableJSON(data), html = Mustache.to_html($("#gallery_photo_template").html(), photo);
    
    $("#photo_gallery").prepend(html);
    $(".photo:hidden").fadeIn();
    
    //If we're in live photo mode, update the photo
    if($("#fullscreen_photo:not(.dont_update)").length > 0){
      var img = $("#fullscreen_photo img");
      
      prepareFullscreenImage(photo["photo"][imageTypeForScreen()+"_src"]);
    }
  };
  
  //Cachebusting
  window.updatePhoto = function(data){
    var photo = photoToUsableJSON(data), html = Mustache.to_html($("#gallery_photo_template").html(), photo);
    
    $("#photo_gallery .photo[data-photo-id="+photo.id+"]").replaceWith(html);
    $(".photo:hidden").fadeIn();
    
    //If we're in live photo mode, update the photo
    if($("#fullscreen_photo:not(.dont_update)").length > 0){
      var img = $("#fullscreen_photo img");
      
      prepareFullscreenImage(photo["photo"][imageTypeForScreen()+"_src"]);
    }
  }
  
  window.appendPhoto = function(data){
    var photo = photoToUsableJSON(data), html = Mustache.to_html($("#gallery_photo_template").html(), photo);
    
    $("#photo_gallery").append(html);
    $(".photo:hidden").fadeIn();
  }
  
  window.loadGalleryPhotos = function(params, f){
    console.log("Load");
    $.getJSON($("#photo_gallery").attr("data-json-url"), {limit: params.limit, before: params.before}, function(data){
      
      $.each(data, function(i, photo_data) {
        appendPhoto(photo_data);
      });
      
      if (typeof f == "function") f(data); //Callback
    });
  }
  
  //Load photos to the bottom of the screen
  window.loadToBottom = function(){
    
    var at_the_bottom = ($("html").height() - $(window).innerHeight() - $(window).scrollTop()) <= 0,
    room_for_more = $(".photo:last").position().top < $(window).innerHeight();
    
    if(at_the_bottom || room_for_more){
      
      //Find the last photo, and load ones older than that
      var last_photo = $(".photo:last").attr("data-photo-id");
      
      loadGalleryPhotos({limit: 4, before: last_photo}, function(data){
        if(data.length){ //Only recurse if there's more to load
          loadToBottom();
        }
      });
    }
  }
  
  //If the window scrolls to the bottom, load some more photos
  $(document).scroll(function(){
    loadToBottom();
  });
  
  if($("#photo_gallery").length > 0){
    //Load photos asynchronously on page load
    loadGalleryPhotos({limit: 4}, function(data){
      loadToBottom();
    });
  }
  
  //The live photo cast
  $("#show_latest_photos").on("click", function(){
    prepareFullscreenImage( $(".photo a:first img").attr("data-"+imageTypeForScreen()+"-src") );
  });
  
  //Show a photo fullscreen
  $("#photo_gallery").on("click", ".photo a:not(.hide_photo)", function(){
    prepareFullscreenImage( $(this).find("img").attr("data-"+imageTypeForScreen()+"-src") );
    //This isn't the live photo cast, though
    $("#fullscreen_photo").addClass("dont_update").css({"background-color": "rgba(0,0,0,0.75)"});
    return false;
  }).on("click", ".photo a.hide_photo", function(){
    $(this).parent().fadeOut(500, function(){$(this).remove()});
    return false;
  });
  
  function getImageSourceFromElement(image_el){
    return image_el.attr("data-"+imageTypeForScreen()+"-src");
  }
  
  function prepareFullscreenImage(image_src){
    
    if($('#fullscreen_photo').length > 0){
      //There's already a photo on display
    }else{
      $("body").append('<div id="fullscreen_photo"></div>'); 
    }
    
    var fullscreen_photo_div = $("#fullscreen_photo");
    fullscreen_photo_div.append('<img src="'+image_src+'" class="new" />');
    fullscreen_photo_div.css({height: Math.max($("html").height(), $(window).outerHeight())});
    
    var img = $("#fullscreen_photo img.new"), image_load_fired = false;
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
      }, 3000);
    
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
    });
    $("#fullscreen_photo img.new").fadeIn(500, function(){
      $(this).removeClass("new");
    });
  }
  
  function closeFullscreen(){
    $("#fullscreen_photo").fadeOut(1000, function(){$(this).remove();});
  }
  
  function resizeAndPositionImage(img){
    var browserwidth = $(window).width(), browserheight = $(window).height();
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