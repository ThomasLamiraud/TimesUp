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
        updateWords("result")
        return;
      } else {
        if (window.location.href.split("/").pop() !== "play") {
          clearTimeout(timer);
          console.log("no play Timer --> " + count);
          counter();
        } else {
          $time.html(count);
          console.log("play Timer --> " + count);
        }
      }

      timer = setTimeout(function(){
        counter();
      }, 1000);
    };

  counter();

  $('.js-timer-btn').on('click', function(){
    clearTimeout(timer);
    if ($(this).hasClass('js-timer-restart')) {
      count = $('.js-timer-display').data('timer-value');
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

function updateWords(successUrl) {
  if (document.found_words.length > 0) {
    $.ajax({
      url: '/update_words',
      type: 'PUT',
      dataType: 'json',
      data: { words: JSON.stringify(document.found_words),
              player_id: $('.js-player-informations').data("player-id"),
              game_slug: window.location.pathname.split("/")[2]
            },
      success: function(data) {
        $('.js-timer-sentence').html("Results updated Click on 'End player turn' button to end your turn.");
        redirectToUrl("play", successUrl)
      },
      error: function(e) {
        $('.js-timer-sentence').html("result not updated, something went wrong, call IT");
        console.log(e);
      }
    });
  } else {
    $('.js-timer-sentence').html("No Results to update Click on 'End player turn' button to end your turn.");
    redirectToUrl("play", successUrl)
  }
}
