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
    last_photo = $(".photo:last"),
    last_photo_pos = last_photo.length ? $(".photo:last").position().top : 0,
    room_for_more = last_photo_pos < $(window).innerHeight();
    
    if(at_the_bottom || room_for_more){
      
      //Find the last photo, and load ones older than that
      var last_photo_id = last_photo.attr("data-photo-id");
      
      loadGalleryPhotos({limit: 4, before: last_photo_id}, function(data){
        if(data.length){ //Only recurse if there's more to load
          loadToBottom();
        }
      });
    }
  }
  
  if($("#photo_gallery").length > 0){
    //Load photos asynchronously on page load
    loadGalleryPhotos({limit: 4}, function(data){
      loadToBottom();
    });
    
    //If the window scrolls to the bottom, load some more photos
    $(document).scroll(function(){
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
  
  window.twentyfour_to_twelve_hour = function(date){
    var tf_h = date.getHours(),
    tw_h = tf_h%12,
    pm = (tf_h/12 >= 1);
    
    //Show both 0000 today and the next day as 12am today, event though that's wrong
    tw_str = (tw_h == 0 ? 12 : tw_h);
    
    return ""+tw_str+(pm ? "pm" : "am");
  }
  
  function numberToOrdinal(n) {
     var s=["th","st","nd","rd"],
         v=n%100;
     return n+(s[(v-20)%10]||s[v]||s[0]);
  }
  
  if($(".pretty_time").length){
    
    var months = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ];
    
    var time_p = $(".pretty_time"),
    starts = new Date(time_p.attr("data-utc-starts")),
    ends = new Date(time_p.attr("data-utc-ends")),
    time_string = "";
    
    if(isNaN(starts.getTime()) || isNaN(ends.getTime())){
      return false;
    }
    
    //If the event is multiday, show the dates, otherwise show times
    //If the event ends at midnight, treat that as 'the same day'
    if(starts.getDate() == (new Date(ends-1)).getDate()){
      
      // Xam - Ypm, Zth of M
      var starts_string = twentyfour_to_twelve_hour(starts),
      ends_string = twentyfour_to_twelve_hour(ends),
      date_string = numberToOrdinal(starts.getDate())+" "+months[starts.getMonth()];
      
      time_string = starts_string+" - "+ends_string+", "+date_string;
      
    }else{
      //Xth - Yth M
      time_string = numberToOrdinal(starts.getDate())+" - "+numberToOrdinal(ends.getDate())+" "+months[starts.getMonth()];
    }
    
    time_p.html(time_string);
    
  }
  
});