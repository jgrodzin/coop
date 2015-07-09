$(document).ready(function() {
  setTimeout(function() {
    $(".notifications").fadeOut();
  }, 1000);

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
});
