function updateScore() {
  currentScore = $(".js-score").data('score');
  newScore = currentScore + 1;
  if (newScore <= parseInt($(".js-max-score").html())) {
    $(".js-score").data('score', newScore);
    $(".js-score").html(newScore);
  }
}
