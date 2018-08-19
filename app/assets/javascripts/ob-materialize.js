$(document).on('turbolinks:load', function() {
  Materialize.Modal._count = 0;
  $('.modal').modal();
});

$(document).on('turbolinks:load', function() {
  $(".dropdown-button").dropdown({ hover: true, belowOrigin: true });
  $(".button-collapse").sideNav();
  $('select').material_select();
});

$(document).on('ready page:change', function() {
  Waves.displayEffect();
});