$(document).on('turbolinks:load', function() {
  doInitialize();
});

function doInitialize() {
  if ($('[data-available-words]').length > 0) {
    setWords()

    $('.js-next-word').on('click', function (event) {
      displayNextWord()
    });

    $('.js-success-word').on('click', function (event) {
      updateScore()
      removeWord()
      displayNextWord()
    })

    $('.js-update-word-status').on('click', function (event) {
      updateWords()
    })
  }
}

function setWords() {
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

function updateScore() {
  // document.words[$('.js-next-word').data('current-index')];
  currentScore = $(".js-score").data('score');
  newScore = currentScore + 1;
  if (newScore <= parseInt($(".js-max-score").html())) {
    $(".js-score").data('score', newScore);
    $(".js-score").html(newScore);
  }
}

function updateWords() {
  if (document.found_words.length > 0) {
    $.ajax({
      url: '/update_words',
      type: 'PUT',
      dataType: 'json',
      data: { words: JSON.stringify(document.found_words) },
      success: function(data) {
        window.location.reload();
      },
      error: function(e) {
        console.log(e);
      }
    });
  }
}
