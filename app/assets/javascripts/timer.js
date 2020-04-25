$(document).on("turbolinks:load", function() {
  doInitializeTimer();
});

function doInitializeTimer() {
  if ($('.js-timer-display').length > 0) {
    initializeTimer()
  }
}

function initializeTimer() {

  var count = $('.js-timer-display').data('timer-value'),
    $time = $('.js-timer-display'),
    timer,
    paused = false,
    counter = function(){
      count--;
      if (count <= 0) {
        $time.html("<h3>Count down complete</h3>");
        updateWords()
        return;
      } else {
        $time.html(count);
        console.log("Timer --> " + count);
      }

      timer = setTimeout(function(){
        counter();
      }, 1000);
    };

  counter();

  $('.js-timer-btn').on('click', function(){
    clearTimeout(timer);
    if ($(this).hasClass('js-timer-restart')) {
      count = 0;
      paused = false;
      counter();
    } else {
      paused = !paused;
      if (!paused) {
        counter();
      }
    }
  });
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
