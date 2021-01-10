class Flash {
  constructor() {
    this.flash = $('[data-flash]')
  }

  setup() {
    this.flash.slideDown()
  }

  listen() {
    $('body').on('click', '[data-flash-close]', (event) => {
      this.flash.hide()
    })
  }
}

$(document).on('turbolinks:load', () => {
  if ($('[data-page-behaviour-flash]').length > 0) {
    const flash = new Flash()
    flash.setup()
    flash.listen()
  }
})