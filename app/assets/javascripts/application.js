// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks

// Functions
function getAll(selector) {
  return Array.prototype.slice.call(document.querySelectorAll(selector), 0);
}

/////////////////////////////////////////////
// Stashes
/////////////////////////////////////////////

// When add or remove is clicked from the transactions screen, show a field for user input
document.addEventListener('turbolinks:load', () => {

  function toggleStashForm(stashFormId) {
    var stashForm = document.getElementById(stashFormId);
    stashForm.classList.toggle('ob-is-hidden');
  }

  var addButtons = getAll('.add-to-stash');
  var removeButtons = getAll('.remove-from-stash');
  var cancelButtons = getAll('.cancel-stash-input');

  if (addButtons.length > 0) {
    addButtons.forEach(function ($el) {
      $el.addEventListener('click', function (e) {
        e.preventDefault();
        toggleStashForm($el.dataset.target);
      });
    });
  }

  if (removeButtons.length > 0) {
    removeButtons.forEach(function ($el) {
      $el.addEventListener('click', function (e) {
        e.preventDefault();
        toggleStashForm($el.dataset.target);
      });
    });
  }

  if (cancelButtons.length > 0) {
    cancelButtons.forEach(function ($el) {
      $el.addEventListener('click', function (e) {
        e.preventDefault();
        toggleStashForm($el.dataset.target);
      });
    });
  }
});