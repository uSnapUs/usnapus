$(document).ready(function() {
  if($("#photo_gallery")){
    
    //Load all the photos asynchronously on page load
    $.getJSON(window.location, function(data){
      
      $.each(data, function(i, photo_data) {
        appendPhoto(photo_data)
      });
      
    });
    
  }
  
  function photoHTML(data){
    
    var photo = {
      id : data["id"],
      photo : {
        base_src: data["photo"]["url"],
        smaller_src: data["photo"]["polaroid"]["url"],
        alt: data["device_name"]
      }
    }
    
    return Mustache.to_html($("#gallery_photo_template").html(), photo);
  }
  
  window.appendPhoto = function(data){
    $("#photo_gallery").append(photoHTML(data))
    $(".photo:hidden").fadeIn();
  }
  
});