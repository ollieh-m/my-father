class AdminEditSectionPage {
  constructor() {
    this.add_new_version_toggle_id = '#add_new_version_toggle'
    this.$add_new_version_toggle = $(this.add_new_version_toggle_id)
    this.add_new_version_form = this.$add_new_version_toggle.data('form')
  }

  listen() {
    $('body').on('click', this.add_new_version_toggle_id, (event) => {
      event.preventDefault()
      event.stopImmediatePropagation()

      if (this.$add_new_version_toggle.data('closed')) {
        this.$add_new_version_toggle.text('Undo')
        this.$add_new_version_toggle.data('closed', false)
        this.$add_new_version_toggle.after(this.add_new_version_form)
      } else {
        this.$add_new_version_toggle.text('Add new version')
        this.$add_new_version_toggle.data('closed', true)
        this.$add_new_version_toggle.next().remove()
      }
    })
  }
}

$(()=> {
  if ($('.js-class-admin-edit-section-page').length > 0) {
    const page = new AdminEditSectionPage()
    page.listen()
  }
})



