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
  
  window.showDateIncrementer = function(){
    console.log($(".datepicker .ui-state-hover:first-child"))
    var pos = $(".datepicker .ui-state-hover:first-child").position();
    $("#date_incrementer").css({position: "absolute", top: pos.top-35, left: pos.left-50}).fadeIn();
  }
  
  function setEndDate(offset){
    var ends = $("#event_ends"),
    current_ends = new Date(parseInt(ends.val()));
    current_ends.setDate( current_ends.getDate() + offset);
    ends.val( current_ends.getTime() );
  }
  
  $("#date_incrementer").on("click", "a", function(){
    var plus = $(this).hasClass("plus"), el;
    
      console.log(plus)
    if(plus){
      
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
        setEndDate(1);
      }
      
    }else{
      el = $(".datepicker .ui-datepicker-current-day")
      if(el.length > 1){
        el.last().removeClass("ui-datepicker-current-day").find("a").removeClass("ui-state-active");
        setEndDate(-1);
      }
    }
  })
  
  $("form.event .btn-group.privacy").on("click", "a", function(){
    var val = $(this).attr("data-val");
    
    if(val == "public")
      $("#event_is_public").attr("checked", "checked");
    else
      $("#event_is_public").removeAttr("checked");
    
    //Toggle buttons
    $(this).addClass("active").siblings().removeClass("active");
    //Toggle explanation
    $(".explanation").find("."+val).removeClass("hidden").siblings("").addClass("hidden");
    return false;
  })
  
  $("form.event .continue").on("click", function(){
    var required_inputs = [$("#event_location"), $("#event_name")];
    
    $.each(required_inputs, function(i, input){
      input.removeClass("error");
      
      if(input.val().trim() == ""){
        input.addClass("error")
      }
      
    });
    
    if($("form.event input.error").length){
      console.log("errors!");
      return false;
    }
    
    $("#date_incrementer").fadeOut();
    $("form.event .details").fadeOut(500, function(){
      $("form.event .payment .event_name").html($("#event_name").val());
      $("form.event .payment").fadeIn();
    });
    
  });
  
  $(".show_details").on("click", function(){
    $(".pricing .details").fadeIn();
  })
  
});