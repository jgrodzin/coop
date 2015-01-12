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
//= require handlebars.runtime
//= require_tree ./templates
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

  // EVENTS
  $(".add-event-link").click(function(e) {
    e.preventDefault();
    $.ajax({
      url: "/events/new",
      type: "GET",
      success: function(response) {
        $(".add-event-link").hide();
        $("#ajax-form").append(response);
      },
    });
  });

  newEventCreateSuccess = function ( newEventData ) {
    var newEvent;
    $(".add-event-link").show();
    $("#ajax-form .new_event").remove();

    newEventData.date = moment(newEventData.date, "YYYY MM DD").format('MMMM D, YYYY');
    newEvent = HandlebarsTemplates.event(newEventData);
    // debugger;
    $(".cards").append(newEvent);
    // $(".container").append("hello!")
    // newEvent.insertAfter($(".card").last());
  };

  $(document).on('submit', '.new_event', function(e) {
    e.preventDefault();
    var myForm =  $(this).serialize();
    $.ajax({
      url:'/events/',
      type:"POST",
      data: myForm
    }).done(newEventCreateSuccess);
  });

  //shopping cart
  $('.new_cart_item').click(function(e) {
    $(this.parentElement).parent().addClass("insideCart");
  });
});


