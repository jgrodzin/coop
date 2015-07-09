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

//= require lodash
//= require jquery
//= require jquery_ujs
//= require rails_jskit
//= require moment
//= require list
//= require list.fuzzysearch
//= require handlebars.runtime
//= require jquery.maskedinput

//= require_tree .

$(document).ready(function() {
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
      var product_id = newCartItemData[newCartItemData.length - 1].product_id
      var cart_item_id = newCartItemData[newCartItemData.length - 1].id
      var shopping_cart_id = newCartItemData[0].shopping_cart_id
      var event_id = this.url.split(/events/)[1][1]
      var route = "/events/3/shopping_carts/24/cart_items/" + cart_item_id + "?from=shopping_cart_list"
      $(".form#"+product_id).children().hide();
      $(".form#"+product_id).append("<div class='remove-from-cart'><a data-confirm='Remove item from cart?' data-method='delete' href=" + route + " " + "rel='nofollow'>Remove from cart</a></div>");

    })
    .fail(function() {
      alert('hi!');
    });
  });

// === LIST JS === //
  var monkeyList = new List('shopping-cart-list', {
    valueNames: ['item-name'],
    plugins: [ ListFuzzySearch() ]
  });
});
