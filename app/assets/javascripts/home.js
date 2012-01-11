$(document).ready(function() {
  
  $("#the_black").css("height", $(window).height());
  
  $(".cta").on("click", function(){
    $('html, body, .content').animate({scrollTop: $("#the_black").position().top}, "slow");
    return false;
  });
  
  $("#new_signup").on("ajax:beforeSend", function(){
    $(".dropus").hide().html("Thanks, we love you! We'll be in touch soon :)<br />Have a fantastic day.").fadeIn()
    return false;
  })
})