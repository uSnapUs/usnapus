$(document).ready(function() {
  
  if($("#photo_gallery").length > 0){
    
    //Load all the photos asynchronously on page load
    $.getJSON(window.location+".json", function(data){
      
      $.each(data, function(i, photo_data) {
        appendPhoto(photo_data)
      });
      
    });
    
  }
  
  window.appendPhoto = function(data){
    
    var html = Mustache.to_html($("#gallery_photo_template").html(), photoToUsableJSON(data));
    
    $("#photo_gallery").append(html)
    $(".photo:hidden").fadeIn();
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
  
  window.pushPhotoToSlideshow = function(data){
    
    
    var photo = photoToUsableJSON(data);
    
    var pushed_photo = false;
    
    //Load the image in a hidden div
    $("body").append('<img src="'+photo["photo"]["base_src"]+'" id="preload_'+photo["id"]+'" style="display:none;"/>');
    $("#preload_"+photo["id"]).load(function(){
      
      //For various reasons, this might not fire.
      // So we have a backup timeout
      
      if(!pushed_photo){
        addPhotoToSlideshow(photo);
        pushed_photo = true;
        $("#preload_"+photo["id"]).remove();
      }
      
    });
    
    //Backup incase load doesn't fire
    window.setTimeout(function() {  
      if(!pushed_photo){
        addPhotoToSlideshow(photo);
        pushed_photo = true;
        $("#preload_"+photo["id"]).remove();
      }
    }, 10000);//Give it a chance to load
  }
  
  //This actually puts in in the slideshow, but is used internally
  function addPhotoToSlideshow(photo){
    
    //Increase the displayed # of slides (which start at 1)
    var counter = $("#slidecounter .totalslides");
    var current_count = parseInt(counter.html());
    counter.html(current_count+1);
    
    photo["slide_id"] = current_count; //slide counts start at 0
    
    //Push it into the JS array of slides
    api.options.slides.push({
      image: photo["photo"]["base_src"],
      thumb: photo["photo"]["smaller_src"],
      title: photo["alt"]});
      
    //Add the HTML to display
    $("ul#supersized").append(Mustache.to_html($("#supersized_slide_template").html(), photo));
    $("#thumb-list").append(Mustache.to_html($("#supersized_thumb_template").html(), photo));
    $("#thumb-list").css({width: $("#thumb-list").width()+$("#thumb-list li:first").width()});
    $("#slide-list").append(Mustache.to_html($("#supersized_bullet_template").html(), photo));
    
    //Tell supersized to proportion the images properly
    //Telling it to resize too soon doesn't work...
    window.setTimeout(function() {  
      resizeSupersized();
    }, 500);
    
    //Go to the latest slide
    console.log(current_count+1);
    api.goTo(current_count+1);
  }
  
});