class AdminSectionsPage {
  constructor() {
    this.add_new_section_link_id = '#add_new_section_link'
    this.$add_new_section_link = $(this.add_new_section_link_id)
    this.$sections = $('.sections')
    this.add_new_section_form = this.$add_new_section_link.data('form')
  }

  listen() {
    $('body').on('click', this.add_new_section_link_id, (event) => {
      event.preventDefault()
      event.stopImmediatePropagation()

      this.$sections.append(this.add_new_section_form)
    })
  }
}

$(()=> {
  if ($('.js-class-admin-sections-page').length > 0) {
    const page = new AdminSectionsPage()
    page.listen()
  }
})



