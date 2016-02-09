App.createController("ShoppingCarts", {
  actions: ["index"],

  index: function() {
    this.cacheElements();
    this.registerEvents();
  },

  cacheElements: function() {
    this.searchInput = $(".fuzzy-search");
    this.clearSearchButton = $(".clear-search");
  },

  registerEvents: function() {
    this.searchInput.on("input", this.toggleClearButton);
    this.clearSearchButton.on("click", this.hideButton);
  },

  toggleClearButton: function() {
    if (($(".fuzzy-search")).val() !== "") {
      this.showButton();
    } else {
      this.hideButton();
    }
  },

  hideButton: function() {
    $(".fuzzy-search").val("");
    $(".clear-search").addClass("hidden");
  },

  showButton: function() {
    $(".clear-search").removeClass("hidden");
  }
});
