$(document).on('turbolinks:load', function() {
  if ($('.js-result-page').length > 0) {
    doInitialization();
  }
});

function doInitialization() {
  slug = $('.js-result-page').data("game-slug");
  if (slug !== undefined) {
    createResultChannel(slug);
  }
}

function createResultChannel(slug) {
  App.results = App.cable.subscriptions.create({channel: 'ResultsChannel', slug: slug}, {
    received: function(data) {

      if (data.is_finished === true) {
        $('.js-result-sentence').html(this.displayFinishSentence());
      }
      $('.js-result-table-body').html(this.renderResultTable(data));
    },

    renderResultTable: function(data) {
      tableLines = ""
      $.each(data.turns_data, function(index, turn_data) {
        tableLines +=  `<tr>
                   <th scope='row'>` + turn_data.player.name + `</th>
                   <td>` + turn_data.score_turn_1 + `</td>
                   <td>` + turn_data.score_turn_2 + `</td>
                   <td>` + turn_data.score_turn_3 + `</td>
                   <td>` + turn_data.total_score + `</td>
                 </tr>`
      })
      return tableLines;
    },

    displayFinishSentence: function() {
      return "<p> C'est fini, merci d'avoir participer n'hésitez à faire une donation à la fondation Toto®</p>";
    }
  });
}
