/*
 * This file was added after finding incompatibilities between the materialize-sass 1.0.0-rc1 gem and materialize-form gem
 * The code here was adapted from materialize-form and altered to reflect class/object names in the latest version of materialize
 

window.materializeForm = {
  init: function() {
    this.initSelect()
    this.initCheckbox()
    this.initDate()
  },
  initSelect: function() {
    $('select[multiple="multiple"] option[value=""]').attr('disabled', true)
    $('select').select()                  // Changed from material_select
  },
  initCheckbox: function() {
    $('input[type=checkbox]').addClass('filled-in')
  },
  initDate: function() {
    $('input.date').datepicker({          // Changed from pickadate
      selectMonths: true,
      selectYears: 100
    });
  }
}

$(document).ready(function() {
  window.materializeForm.init()
});

$(document).ajaxSuccess(function() {
  window.materializeForm.init()
});

$(document).ready(function(){
  $('.tooltipped').tooltip();
});
*/