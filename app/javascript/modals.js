$(document).on('click', '[data-modal-target]', (event) => {
  event.preventDefault()

  modal = $(event.currentTarget.dataset.modalTarget)
  modal.find('button').prop('disabled', false)
  modal.removeClass('hidden')
});

$(document).on('click', '[data-modal-close]', (event) => {
  event.preventDefault()

  modal = $(event.currentTarget.closest(".modal"))
  modal.find('button').prop('disabled', true)
  modal.addClass("hidden")
});

