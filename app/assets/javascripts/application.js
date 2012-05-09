// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap.min
//= require placeholder.jquery
//= require mustache
//= require devise
//= require events
//= require home
//= require photos
//= require signups
//= require purchases

$(document).ready(function() {
  $('input, textarea').placeholder();
  window.showAlert = function(alert_type, alert_heading, alert_message){
    var html = Mustache.to_html($("#alert_template").html(), {
      "alert_type": alert_type,
      "alert_heading": alert_heading,
      "alert_message": alert_message
    });

    $("#alert-area").append(html);
    $(".alert:hidden").fadeIn();
    $("#alert-area").on("click", ".close", function(){
      $(this).parents(".alert:first").fadeOut();
    });
  };
});
