function updateScore() {
  currentScore = $(".js-score").data('score');
  newScore = currentScore + 1;
  if (newScore <= parseInt($(".js-max-score").html())) {
    $(".js-score").data('score', newScore);
    $(".js-score").html(newScore);
  }
}

function updateScoreTable(game_slug, successUrl) {
  $.ajax({
    url: '/broadcast_score_table',
    type: 'PUT',
    dataType: 'json',
    data: { slug: game_slug }
  })
  .done(function(data) {
    redirectToUrl("play", successUrl)
  })
  .fail(function(jqxhr, status, exception) {
    console.log('updateScoreTable error');
    console.log(jqxhr);
    console.log(status);
    console.log(exception);
  });
}
