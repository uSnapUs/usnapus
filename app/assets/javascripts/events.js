$(document).ready(function() {

  var geocoder, map, marker;
  
  window.updateLatLng = function(){
    if(marker !== undefined){
      $("#event_latitude").val(marker.getPosition().lat());
      $("#event_longitude").val(marker.getPosition().lng());
    }
  }
  
  window.updateLocation = function(){
    if(marker !== undefined){
      $.getJSON("/geocode_search.json", {
          "search": marker.getPosition().lat()+", "+marker.getPosition().lng()
        }, 
        function(data){
          console.log(data);
          if(data.length){
            $("#event_location").val(data[0]["data"].formatted_address);
          }
        }
      );
    }
  }
  
  //Find a location for the event, either the event's existing location, user's current position, or SF
  window.getDefaultPosition = function(selector, callback){
    
    //Try and get existing position
    var map = $("#"+selector);
    var lat = map.attr("data-lat"), lng = map.attr("data-lng");
    
    if(lat !== undefined && lng !== undefined){
      
      if (typeof callback == "function") callback({lat: lat, lng: lng});
      return;
    
    //No existing position
    }else{
      
      var coords = {lat: 37.793508, lng: -122.419281}; //San Francisco

      // Check for geolocation support
      if (navigator.geolocation) {

      	// Use getCurrentPosition to async get coordinates and then fire callback
      	navigator.geolocation.getCurrentPosition(

      	//Geolocation
      	  function (position) {
      		  coords.lat = position.coords.latitude;
      		  coords.lng = position.coords.longitude;
      		  if (typeof callback == "function") callback(coords);

      	//No geolocation
      	}, function(){
      	  if (typeof callback == "function") callback(coords);
      	});
      }
      
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
      mapTypeId: google.maps.MapTypeId.ROADMAP
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
      updateLocation();
    });
    
    getDefaultPosition(selector, function(coords){
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
  
  
  $("form.event .btn-group.privacy").on("click", "a", function(){
    var val = $(this).attr("data-val");
    
    if(val == "public")
      $("#event_is_public").val(1);
    else
      $("#event_is_public").val(0);
    
    //Toggle buttons
    $(this).addClass("active").siblings().removeClass("active");
    //Toggle explanation
    $(".explanation div.hidden").removeClass("hidden").siblings().addClass("hidden");
    return false;
  })
  
  if($(".btn-group.privacy").length){
    if($(".btn-group.privacy").attr("data-is-public") == "false"){
      //Toggle buttons
      $(".btn-group.privacy .btn.active").removeClass("active").siblings().addClass("active");
      //Toggle explanation
      $(".explanation").find(".private").removeClass("hidden").siblings().addClass("hidden");
    }
  }
  
  function checkEventFields(){
    var required_inputs = [$("#event_location"), $("#event_name"), $("#event_code")];
    
    $.each(required_inputs, function(i, input){
      input.removeClass("error");
      
      if(input.val().trim() == ""){
        console.log(input);
        input.addClass("error");
      }
      
    });
    
    if($("form.event input.error").length){
      return false;
    }
    return true;
  }
  
  $("form.event").on("click", ".continue", function(){
    
    if(!checkEventFields())
      return false;
      
    $("form.event .details, .ui-autocomplete, #date_incrementer").fadeOut(500, function(){
      $("form.event .payment .event_name").html($("#event_name").val());
      $("form.event .payment").fadeIn();
    });
    
  }).on("submit", function(){
    if(!checkEventFields())
      return false;
  });
  
  window.showRange = function(starts_msec, ends_msec){
    var diff = (ends_msec-starts_msec)/60/60/24;
    //Show multiple selected dates
    for(i = 1; i < diff; i++){
      el = $(".datepicker .ui-datepicker-current-day:last + td");

      if(!el.length){
        //Try go to the next row
        var row = $(".datepicker .ui-datepicker-current-day:last").parent().next();
        if(row.length){
          el = $(".datepicker .ui-datepicker-current-day:last").parent().next().find("td:first-child");
        }
      }
      if(el.length){
        el.addClass("ui-datepicker-current-day").find("a").addClass("ui-state-active");
      }
    }
  }
  
  $(".show_details").on("click", function(){
    $(".pricing .details").fadeIn();
  })
  
  $("#event_code").on("keyup", function(){
    $("#event_code_tip").html($("#event_code").val());
  });
  
  var form = $("form.event");
  
  function goToStep(step){
    
    form.attr("data-step", step);
    
    $("div.active").removeClass("active").addClass("hidden");
    $("div[data-step="+step+"]").removeClass("hidden").addClass("active");
    
    $(".steps a.active").removeClass("active");
    $(".steps a[data-step="+step+"]").addClass("active");
    
    if(step == 2){
      google.maps.event.trigger(map, 'resize');
    }
    
  }
  
  
  
  form.on("click", "a.next", function(){
    
    var step = parseInt(form.attr("data-step"))+1;
    
    if(step <= 4){
      goToStep(step);
    }
    
    return false;
  }).on("click", ".steps a", function(){
    console.log($(this))
    var step = parseInt($(this).attr("data-step"));
    console.log(step)
    goToStep(step);
    
    return false;
  })
  
});