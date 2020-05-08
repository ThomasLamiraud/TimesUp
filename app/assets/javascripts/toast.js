$(document).on('turbolinks:load', function() {
  $(".toast").toast({ autohide: false })
  $(".toast").toast('show');
});
