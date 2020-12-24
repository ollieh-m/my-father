$(document).on('click', '[data-modal-target]', (event) => {
  event.preventDefault()

  $(event.currentTarget.dataset.modalTarget).removeClass("hidden")
});

$(document).on('click', '[data-modal-close]', (event) => {
  event.preventDefault()

  $(event.currentTarget).closest(".overlay__wrapper").addClass("hidden")
});

