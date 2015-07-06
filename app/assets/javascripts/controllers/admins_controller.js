App.createController("Admins", {
  actions: ["edit_member"],

  edit_member: function() {
    $("#member_phone").mask("999-999-9999");
  }
});
