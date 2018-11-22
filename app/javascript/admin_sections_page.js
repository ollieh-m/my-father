class AdminSectionsPage {
  constructor() {
    this.add_new_section_link_id = '#add_new_section_link'
    this.$add_new_section_link = $(this.add_new_section_link_id)
    this.$sections = $('.list')
    this.add_new_section_form = this.$add_new_section_link.data('form')
  }

  setup() {
    update = (e, ui) => {
      console.log(this.$sections.sortable("serialize"))
    }

    this.$sections.sortable({
      axis: "y",
      cancel: "div.not-sortable",
      cursor: "move",
      opacity: 0.5,
      revert: 200,
      update: update
    })
  }

  listen() {
    $('body').on('click', this.add_new_section_link_id, (event) => {
      event.preventDefault()
      event.stopImmediatePropagation()

      this.$sections.append(this.add_new_section_form)
    })

    $('body').on('submit', 'form.new_create_section', (event) => {
      event.preventDefault()
      event.stopImmediatePropagation()

      // prepare nested form data
      data = {create_section: {}}
      $(event.currentTarget).serializeArray().forEach((param) =>{
        sectionParam = param.name.match(/create_section\[([a-z]+)\]/)
        if (sectionParam) {
          data.create_section[sectionParam[1]] = param.value
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
          $(event.currentTarget).parent().replaceWith(response.section)
        });
    })
  }
}

$(document).on('turbolinks:load', () => {
  if ($('.js-class-admin-sections-page').length > 0) {
    const page = new AdminSectionsPage()
    page.setup()
    page.listen()
  }
})



