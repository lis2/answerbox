
$(function() {
    availableTags = $.getJSON('/tags.json', function(data) {
      var availableTags = [];
      $.each(data, function(key, val) {
        availableTags.push(val.name);
      });
      $( "#tags" ).autocomplete({
        source: availableTags,
        close: function( event, ui ){
          $.ajax("/questions/" + $(this).val() + "/filter");
        }
      });
       
    });    
});
 
  