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
  
  var form = $("form.event");
  
  var step_instructions = [
    {title: "So, what's the occasion?", subtitle: "Just name your event to get started. Try it for free, pay when you're ready."},
    {title: "Where is X taking place?", subtitle: "Add a location so guests can instantly share their photos."},
    {title: "What day is X?", subtitle: "Guests will be able to join your event on this day"},
    {title: "How can guests access X?", subtitle: "These privacy settings keep your memories safe"},
    {title: "You're almost ready to go!", subtitle: "Just choose when to pay."}
  ]
  
  function goToStep(step){
    
    if(checkPreviousStep(step-1)){
      form.attr("data-step", step);
      form.attr("data-max-step", Math.max(step, parseInt(form.attr("data-max-step"))));

      instr = step_instructions[step-1];
      form.find(".top .title").html(instr.title.replace("X", $("#event_name").val()));
      form.find(".top .subtitle").html(instr.subtitle);

      $("div.active").removeClass("active").addClass("hidden");
      $("div[data-step="+step+"]").removeClass("hidden").addClass("active");

      $(".steps a.active").removeClass("active");
      $(".steps a[data-step="+step+"]").addClass("active");

      if(step == 2){
        google.maps.event.trigger(map, 'resize');
      }
      else if(step == 5){
        $(".next").addClass("hidden");
        $("input[type=submit].free").removeClass("hidden");
      }
       _gaq.push(['_trackEvent', 'SignUpStep', step]);
      setNextButton();
    }
    
  }
  
  function checkPreviousStep(step){
    switch(step){
    case 1:
      if($("#event_name").val().trim() == ""){
        $("#event_name").addClass("error");
        return false;
      }
      break;
    case 2:
      if($("#event_location").val().trim() == ""){
        $("#event_location").addClass("error");
        return false;
      }
      break;
    case 3:
      if($("#event_starts").val().trim() == ""){
        $("#event_starts").addClass("error");
        return false;
      }
      break;
    case 4:
      if(!checkEventCode()){
        return false;
      }
      break;
    }
    return true;
  }
  
  form.on("click", "a.next", function(){
    
    var next_step = parseInt(form.attr("data-step"))+1;
    if(next_step <= 5){
      goToStep(next_step);
    }
    return false;
    
  }).on("click", ".steps a", function(){
    var next_step = parseInt($(this).attr("data-step"));
    var max_step = parseInt(form.attr("data-max-step"));
    console.log(next_step+" <= "+max_step);
    if(next_step <= max_step){
      goToStep(next_step);
    }
    return false;
  }).on("click", "input.free", function(){
    $("#event_free").val(1);
  }).on("submit", function(){
    if( $("#accept").length && ($("#accept").attr("checked") != "checked") ){
      $("label[for=accept]").addClass("red");
      return false;
    }
  });
  
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
  
  
  $(".show_details").on("click", function(){
    $(".pricing .details").fadeIn();
  })
  
  function checkEventCode(){
    var code = $("#event_code");
    var vc = $(".valid_chars");
    
    if( code.val().match(/^[a-zA-Z0-9\-]+$/) == null){
      code.addClass("error");
      vc.fadeIn();
      return false;
    }else{
      code.removeClass("error");
      vc.fadeOut();
    }
    return true;
  }
  
  $("#event_code").on("keyup", function(){
    var code = $("#event_code").val();
    if(checkEventCode())
      $("#event_code_tip").html($("#event_code").val());
  });
  
  //Watch event inputs and enable next button
  form.on("keyup", "input", function(){
    setNextButton()
  });
  
  function setNextButton(){
    if($(".next").length){
      if($("input:visible").length && !$("input:visible").val().length){
        $(".next").removeClass("btn-green").addClass(".btn-blue .disabled");
      }else{
        $(".next").addClass("btn-green").removeClass(".btn-blue .disabled");
      }
    }
  }
  
});