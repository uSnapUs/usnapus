$(document).ready(function() {
  if($("#photo_gallery")){
    
    //Load all the photos asynchronously on page load
    $.getJSON(window.location, function(data){
      
      $.each(data, function(i, photo_data) {
        appendPhoto(photo_data)
      });
      
    });
    
  }
  
  window.appendPhoto = function(data){
    
    var photo = {
      id : data["id"],
      photo : {
        base_src: data["photo"]["url"],
        smaller_src: data["photo"]["polaroid"]["url"],
        alt: data["device_name"]
      }
    }
    
    var html = Mustache.to_html($("#gallery_photo_template").html(), photo);
    
    $("#photo_gallery").prepend(html)
    $(".photo:hidden").fadeIn();
  }
  
});