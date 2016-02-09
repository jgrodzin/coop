App.createController("Products", {
  actions: ["index"],

  index: function() {
    this.bodyTag = $("body");
    this.cacheElements();
    this.registerEvents();
  },

  cacheElements: function() {
    this.hiddenTableRows = $("tr.hidden");
    this.formEdit = $(".modal-form");
    this.editButton = $(".edit-link");
    this.cancelButton = $(".cancel-button");
  },

  registerEvents: function() {
    this.editButton.on("click", this.toggleForm);
    this.cancelButton.on("click", this.hideForm);
  },

  toggleForm: function(e) {
    var productId = e.target.id;
    var formRowWithId = $("tr#"+productId+".hidden");
    formRowWithId.toggleClass("hidden");
  },

  hideForm: function(e) {
    var productId = e.target.parentElement.id;
    $("tr#"+productId+".edit-row-form").addClass("hidden");
  }
});
