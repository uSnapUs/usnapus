$(document).ready(function() {
  
  $(selector).keyup(function () {
    typewatch(function () {
      // executed only 500 ms after the last keyup event.
      console.log("Ping!")
    }, 500);
  });

  var typewatch = (function(){
    var timer = 0;
    return function(callback, ms){
      clearTimeout (timer);
      timer = setTimeout(callback, ms);
    }  
  })();
}