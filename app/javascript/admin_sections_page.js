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

    $('body').on('submit', 'form.new_section', (event) => {
      event.preventDefault()
      event.stopImmediatePropagation()

      // prepare nested form data
      data = {section: {}}
      $(event.currentTarget).serializeArray().forEach((param) =>{
        sectionParam = param.name.match(/section\[([a-z]+)\]/)
        if (sectionParam) {
          data.section[sectionParam[1]] = param.value
        } else {
          data[param.name] = param.value
        }
      })

      $.ajax({
        method: "POST",
        url: event.currentTarget.action,
        dataType: 'json',
        contentType: 'application/json',
        data: JSON.stringify(data)
      })
        .done((response) => {
          $(event.currentTarget).replaceWith(response.section)
        });
    })
  }
}

$(()=> {
  if ($('.js-class-admin-sections-page').length > 0) {
    const page = new AdminSectionsPage()
    page.listen()
  }
})



