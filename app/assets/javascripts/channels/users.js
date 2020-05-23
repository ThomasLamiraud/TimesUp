$(document).on('turbolinks:load', function() {
  if ($('.js-user-id').length > 0) {
    doInitialization();
  }
});

function doInitialization() {
  user_id = $('.js-user-id').data("user-id");
  if (user_id !== undefined) {
    createUsersChannel(user_id);
  }
}

function createUsersChannel(user_id) {
  App.results = App.cable.subscriptions.create({channel: 'UsersChannel', id: user_id}, {
    received: function(data) {
      $('body[data-user-id='+user_id+']').find(".toast-position").append(data.notification_partial)
      $(".toast").toast({ autohide: true, delay: 5000 })
      $(".toast").toast('show');
      $('.toast').on('hidden.bs.toast', function () {
        destroyToastDiv($(this))
      })
    }
  });
}
