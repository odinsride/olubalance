$(document).on('turbolinks:load', function() {
  Materialize.Modal._count = 0;
  $('.modal').modal();
});

$(document).on('turbolinks:load', function() {
  $(".dropdown-button").dropdown({ hover: true });
  $(".button-collapse").sideNav();
});

