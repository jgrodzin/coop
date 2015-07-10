App.createController("Products", {
  actions: ["index"],

  index: function() {
    this.bodyTag = $("body");
    this.cacheElements();
    this.registerEvents();
  },

  cacheElements: function() {
    this.formEdit = $(".modal-form");
    this.editButton = $(".edit-link");
  },

  registerEvents: function() {
    this.editButton.on("click", this.toggleForm);
  },

  toggleForm: function(e) {
    productId = e.target.id
    formWithId = $(".modal-form#"+productId)
    formWithId.toggleClass("hidden");
  }

//   cacheElements: function() {
//     this.bodyTag = $("body");
//     this.allEditButtons = $(".edit-button");
//     this.vendorInput = $(".modal-form #product_vendor_id");
//     this.productNameInput = $(".modal-form #product_name");
//     this.priceInput = $(".modal-form #product_price");
//     this.unitInput = $(".modal-form #product_unit_type");
//     this.amountInput = $(".modal-form #product_total_amount_purchased");
//     this.cacheModalElements();
//   },

//   registerEvents: function() {
//     this.closeModal.on("click", this.toggleModal);
//     this.modalInner.on("click", this.stopModalClose);
//     this.allEditButtons.on("click", this.startModal);
//   },

//   startModal: function(e) {
//     var editButton = $(e.currentTarget).closest("button");

//     var productID = editButton[0].id;
//     var eventID = $(editButton[0]).data("event");
//     // insert into form input
//     var vendorID = $(editButton[0]).data("vendor");
//     var productName = $(editButton[0]).data("name");
//     var productPrice = $(editButton[0]).data("price");
//     var productUnitType = $(editButton[0]).data("unit");
//     var productAmount = $(editButton[0]).data("amount");
//     this.vendorInput.val(vendorID);
//     this.productNameInput.val(productName);
//     this.priceInput.val(productPrice);
//     this.unitInput.val(productUnitType);
//     this.amountInput.val(productAmount);

//     // this.modalForm.removeClass = "new_product";
//     // this.modalForm.addClass = "edit_product";
//     // this.modalForm[0].id = "edit_product_" + productID;
//     // this.modalForm[0].method = "patch";
//     // this.modalForm[0].action = "/events/" + eventID + "/products/" + productID;
//     this.modalIntro.append("<h2>Edit "+productName+":</h2>");
//     this.toggleModal();
//   },

//   toggleModal: function() {
//     this.bodyTag.toggleClass("modal-open");
//   },

//   stopModalClose: function(e) {
//     if (e.currentTarget !== this.closeModalButton[0]) {
//       e.stopPropagation();
//     }
//   },

//   cacheModalElements: function() {
//     this.closeModal = $(".modal-close, .modal-fade-screen");
//     this.closeModalButton = $(".modal-close");
//     this.modalInner = $(".modal-inner");
//     this.modalForm = $(".modal-form");
//     this.modalIntro = $(".modal-intro");
//   }
});
