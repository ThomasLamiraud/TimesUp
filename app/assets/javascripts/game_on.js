$(document).on('turbolinks:load', function() {
  doInitialize();
});

function doInitialize() {
  setWords()

  $('.js-next-word').on('click', function (event) {
    displayNextWord()
  });

  $('.js-success-word').on('click', function (event) {
    updateScore()
    removeWord()
    displayNextWord()
  })
}

function setWords() {
  document.words = $('[data-available-words]').data('available-words')
  $('.current-word').html(document.words[0]);
}

function displayNextWord() {
  event.preventDefault()
  current_index = $('.js-next-word').data('current-index');
  index = setIndex(current_index);
  if(document.words.length == 0) {
    $('.current-word').html("No more words");
  } else {
    $('.current-word').html(document.words[index]);
  }
}

function setIndex(current_index) {
  nextIndex = parseInt(current_index) + 1
  if (nextIndex == document.words.length || nextIndex > document.words.length){
    nextIndex = 0
  }
  $('.js-next-word').data('current-index', nextIndex)
  return nextIndex
}

function removeWord() {
  document.words.splice($('.js-next-word').data('current-index'), 1);
}

function updateScore() {
  // document.words[$('.js-next-word').data('current-index')];
  currentScore = $(".js-score").data('score');
  newScore = currentScore + 1;
  $(".js-score").data('score', currentScore + 1);
  $(".js-score").html(newScore);
}
