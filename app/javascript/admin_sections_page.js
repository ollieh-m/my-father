class AdminSectionsPage {
  constructor() {
    this.add_new_section_link_id = '#add_new_section_link'
    this.$add_new_section_link = $(this.add_new_section_link_id)
    this.$sections = $('.list')
    this.add_new_section_form = this.$add_new_section_link.data('form')
  }

  setup() {
    update = (e, ui) => {
      this.$sections.sortable("disable");

      regex = /(\/admin\/parts\/)(\d+)/g;
      partId = regex.exec(window.location.pathname)[2]
      $.ajax({
        method: "PATCH",
        url: `/admin/parts/${partId}/sections/order`,
        dataType: 'json',
        contentType: 'application/json',
        data: JSON.stringify({
          authenticity_token: $('[name="csrf-token"]')[0].content,
          ordered_sections: this.$sections.sortable("toArray")
        })
      }).done((response) => {
          console.log('enable')
          this.$sections.sortable("enable");
        });
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
      $('input#create_section_title').last().focus()
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



