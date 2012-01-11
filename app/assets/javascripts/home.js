$(document).ready(function() {
  
  $("#the_black").css("height", $(window).height());
  
  $(".cta").on("click", function(){
    $('html, body, .content').animate({scrollTop: $("#the_black").position().top}, "slow");
  });
})