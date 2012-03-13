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
    var pos = $(".datepicker .ui-state-hover:first-child").position();
    $("#date_incrementer").css({position: "absolute", top: pos.top-35, left: pos.left-50}).fadeIn();
  }
  
  function setEndDate(offset){
    var ends = $("#event_ends"),
    current_ends = new Date(parseInt(ends.val()));
    current_ends.setDate( current_ends.getDate() + offset);
    current_ends = end_of_date(current_ends.getTime())
    ends.val( current_ends.getTime() );
  }
  
  window.end_of_date = function(ms_since_epoch){
    datetime = new Date();
    datetime.setTime(ms_since_epoch);
    datetime.setHours(23);
    datetime.setMinutes(59);
    datetime.setSeconds(59);
    return datetime;
  }
  
  $("#date_incrementer").on("click", "a", function(){
    var plus = $(this).hasClass("plus"), el;
    
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
  
});