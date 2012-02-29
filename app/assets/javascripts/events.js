$(document).ready(function() {
  
  var ta = $('#event_location').typeahead({
    source: function (typeahead, query) {
      console.log("Source")
      $.getJSON("/geocode_search.json", {"search": query}, function(data){
        var locations = [];
        
        $.each(data, function(i, item){
          var item = item["data"];
          locations.push({
            value:  item.formatted_address,
            lat:    item.geometry.location.lat,
            lng:    item.geometry.location.lng
          })
        });
        
        if(!locations.length){
          locations = [
            {
              value: "No results...",
              lat: 37.793508,
              lng: -122.419281
            }
          ]
        }
        console.log(locations);
        typeahead.process(locations);
      });
    },
    onselect: function(obj) {
      var location = new google.maps.LatLng(obj.lat, obj.lng);
      marker.setPosition(location);
      map.setCenter(location);
    }
  });
  
  var geocoder, map, marker;

  window.initializeMap = function(selector){
  //MAP
  if(!selector||!document.getElementById(selector))
    return;

    var latlng = new google.maps.LatLng(37.793508,-122.419281); //SF
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
      draggable: true
    });
    $("form input:visible:first").focus();
  }
  
  initializeMap("google_map");
});