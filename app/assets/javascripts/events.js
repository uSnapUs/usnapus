$(document).ready(function() {

  var geocoder, map, marker;
  
  window.updateLatLng = function(){
    if(marker !== undefined){
      $("#event_latitude").val(marker.getPosition().lat());
      $("#event_longitude").val(marker.getPosition().lng());
    }
  }
  
  window.getPosition = function(callback){
    var coords = {lat: 37.793508, lng: -122.419281}; //San Francisco
    
    // Check for geolocation support
    if (navigator.geolocation) {
    	// Use method getCurrentPosition to get coordinates
    	navigator.geolocation.getCurrentPosition(function (position) {
    		coords.lat = position.coords.latitude;
    		coords.lng = position.coords.longitude;
    		if (typeof callback == "function") callback(coords); //Callback
    	}, function(){
    	  if (typeof callback == "function") callback(coords); //Callback
    	});
    }
  }
  
  window.initializeMap = function(selector){
    //MAP
    if(!selector||!document.getElementById(selector))
      return;

    var latlng = new google.maps.LatLng(37.793508,-122.419281);
    var options = {
      zoom: 10,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      disableDefaultUI: true
    };

    map = new google.maps.Map(document.getElementById(selector), options);

    //GEOCODER
    geocoder = new google.maps.Geocoder();

    marker = new google.maps.Marker({
      map: map,
      draggable: true,
      flat: true
    });
    
    google.maps.event.addListener(marker, "dragend", function() {
      updateLatLng();
    });
    
    getPosition(function(coords){
      var location = new google.maps.LatLng(coords.lat, coords.lng);
      marker.setPosition(location);
      map.setCenter(location);
      updateLatLng();
    });
    
    $("form input:visible:first").focus();
  }
  
  if($('#event_location').length){
    initializeMap("google_map");
    
    $('#event_location').autocomplete({
      source: function (request, response) {        
        $.getJSON("/geocode_search.json", {"search": request.term}, function(data){            
          response($.map(data, function (item) {
            item = item["data"]
            return {
                label: item.formatted_address,
                value: item.formatted_address,
                lat: item.geometry.location.lat,
                lng: item.geometry.location.lng
            };
          }));  
        });
      },
      select: function(event, ui){
        var location = new google.maps.LatLng(ui.item.lat, ui.item.lng);
        marker.setPosition(location);
        map.setCenter(location);
        map.setZoom(17);
        updateLatLng();
      }
    });
    
  }
  
});