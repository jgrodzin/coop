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
//= require turbolinks
//= require_tree .

$(document).ready(function() {
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

  // function getNewEventForm() {
    $(".add-event-link").click(function(e) {
      e.preventDefault();
      $.ajax({
        url: "/events/new",
        tpye: "GET",
        success: function(response) {
          $(".add-event-link").hide();
          $("#ajax-form").append(response);
        },
      });
    });
  // }

  $('.new-event-form').submit(function()
    {
     var myForm =  $('.new-event-form').serialize();
        $.ajax
         ({
            url:'/events/',
             type:"POST",
             dataType:'json',
             data: myForm,
             processData:false,

             success: function(response) {
              $(".add-event-link").show();
              $("#ajax-form").hide(response);
            },
            error: function (xhr, status)
            {
            alert(xhr.error);
            }
         });
    });
});



// $.ajax({
//   url: "/foo",
//   data: { stuff: "posted" },
//   success: function(response) {
//     debugger
//   },

//   error: function() {
//     console.log("error");
//   }
// });
