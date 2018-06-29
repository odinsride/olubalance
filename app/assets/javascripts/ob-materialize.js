$(document).on('turbolinks:load', function() {
  Materialize.Modal._count = 0;
  $('.modal').modal();
});