$(document).ready(function() {
  $('#signup_email').placeholder();
  $("#the_black").css("height", $(window).height());
  
  $(".cta").on("click", function(){
    $('html, body, .content').animate({scrollTop: $("#the_black").position().top}, "slow");
    return false;
  });
  
  $("#new_signup").on("ajax:beforeSend", function(){
    
    if($("#signup_email").val().trim() === ""){
      $(".dropus").hide().html("Whoops, you need to give us your email. Pretty please?").fadeIn();
      return false;
    }
    
  	$(".new_signup").hide();
    $(".dropus").hide().html("Thanks, we love you! We'll be in touch soon :)<br />Have a fantastic day.").fadeIn();
  
  }).on("ajax:error", function(){
    
    $(".dropus").hide().html("Whoops, looks like that didn't work. Try again?").fadeIn();
    $(".new_signup").fadeIn();
    
  });
});