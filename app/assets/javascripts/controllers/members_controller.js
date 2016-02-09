App.createController("Members", {
  actions: ["edit_account", "new"],

  new: function() {
    $("#member_phone").mask("999-999-9999");
  },

  edit_account: function() {
    $("#member_phone").mask("999-999-9999");
  }
});
