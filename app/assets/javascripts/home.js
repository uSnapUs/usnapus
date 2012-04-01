$(document).ready(function() {
  $('input, textarea').placeholder();
  $("#submit_create").click(function(){
    $("#create_form").submit();
    return false;
  });
});