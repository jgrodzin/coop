App.createController("Members", {
  actions: ["edit_account"],

  edit_account: function() {
    $("#member_phone").mask("999-999-9999");
  }
});
