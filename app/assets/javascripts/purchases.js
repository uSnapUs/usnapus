$("form#new_billing_detail").on("submit", function(){
  
  //Card name be word+space+word
  if($("#billing_detail_card_name").val().match(/^\w+\s.+$/) == null){
    $("#billing_detail_card_name").addClass("error");
    $("#billing_detail_card_name").parent().append('<span class="error help-inline">Please enter a first and last name</span>');
    return false
  }
  
  $("form#new_billing_detail").submit(function(){
    var button = $("button[type=submit]");
    if(button.hasClass("disabled")){
      return false;
    }else{
      button.addClass("disabled").html("Processing...");
    }
  })
  
   _gaq.push(['_trackEvent', 'Purchase', 'submit']);
});