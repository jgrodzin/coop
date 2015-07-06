App.createController("Vendors", {
  actions: ["new", "edit"],

  new: function() {
    $("#vendor_phone").mask("999-999-9999");
  },

  edit: function() {
    $("#vendor_phone").mask("999-999-9999");
  },
});
