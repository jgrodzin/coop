// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require moment
//= require list
//= require list.fuzzysearch
//= require handlebars.runtime
//= require jquery.maskedinput
//= require_tree .

$(document).ready(function() {

  var newEventCreateSuccess;
  var newEventCreateFailure;
  var menu = $('.centered-navigation-menu');
  var menuToggle = $('.centered-navigation-menu-button');
  var signUp = $('.sign-up');

  $(menuToggle).on('click', function(e) {
    e.preventDefault();
    menu.slideToggle(function(){
      if(menu.is(':hidden')) {
        menu.removeAttr('style');
      }
    });
  });

  // === SHOPPING CART === //
  $('.new_cart_item').submit(function(e) {
    var cartItemForm = $(this).serialize();
    var formUrl = $(this).attr('action');
    $(e.target).attr("disabled", "disabled");

    $.ajax({
      url: formUrl,
      type: "POST",
      data: cartItemForm,
    })
    .done(function(newCartItemData) {
      $(".badge.error").html(newCartItemData.length);
      var message = newCartItemData.errors
    })
    .fail(function() {
      alert('hi!');
    });
  });

// === LIST JS === //
  var monkeyList = new List('test-list', {
    valueNames: ['name'],
    plugins: [ ListFuzzySearch() ]
  });
});
