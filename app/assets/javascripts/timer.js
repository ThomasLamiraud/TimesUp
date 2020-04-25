$(document).on("turbolinks:load", function() {
  doInitializeTimer();
});

function doInitializeTimer() {

  if ($('.js-timer-display').length > 0) {
    initializeTimer()
  }
}


function initializeTimer() {
  var counter = 10;
  var interval = setInterval(function() {
    counter--;

    if (counter <= 0) {
      clearInterval(interval);
      $('.js-timer-display').html("<h3>Count down complete</h3>");
      updateWords()
      return;
    } else {
      $('.js-timer-display').html(counter);
      console.log("Timer --> " + counter);
    }
  }, 1000);
}

function updateWords() {
  if (document.found_words.length > 0) {
    $.ajax({
      url: '/update_words',
      type: 'PUT',
      dataType: 'json',
      data: { words: JSON.stringify(document.found_words) },
      success: function(data) {
        $('.js-timer-display').html("Results updated Click on 'End player turn' button to end your turn.");
      },
      error: function(e) {
        $('.js-timer-display').html("result not updated, something went wrong, call IT");
        console.log(e);
      }
    });
  } else {
    $('.js-timer-display').html("No Results to update Click on 'End player turn' button to end your turn.");
  }
}
