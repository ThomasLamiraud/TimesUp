$(document).on('turbolinks:load', function() {
  console.log('game_on');
  doInitializeGameOn();
});

function doInitializeGameOn() {
  console.log("game_on -- doInitialize [before]");
  if ($('[data-available-words]').length > 0) {
    console.log("game_on -- doInitialize [inside]");
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
}

function setWords() {
  console.log("toto");
  document.words = $('[data-available-words]').data('available-words')
  document.found_words = []
  $('.current-word').html(document.words[0]);
}

function displayNextWord() {
  event.preventDefault()
  current_index = $('.js-next-word').data('current-index');
  index = setIndex(current_index);
  if(document.words.length == 0) {
    $('.current-word').html("No more words");
    redirectToUrl("play", "reset_words_status")
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
  word = document.words[$('.js-next-word').data('current-index')];
  document.found_words.push(word)
  document.words.splice($('.js-next-word').data('current-index'), 1);
}
