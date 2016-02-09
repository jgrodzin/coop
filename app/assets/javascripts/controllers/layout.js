$(document).ready(function() {
  setTimeout(function() {
    $(".notifications").fadeOut();
  }, 1000);

  var menu = $(".centered-navigation-menu");
  var menuToggle = $(".centered-navigation-menu-button");

  $(menuToggle).on("click", function(e) {
    e.preventDefault();
    menu.slideToggle(function(){
      if(menu.is(":hidden")) {
        menu.removeAttr("style");
      }
    });
  });
});
