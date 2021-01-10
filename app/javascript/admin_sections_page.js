class AdminSectionsPage {
  constructor() {
    this.add_new_section_link_id = '#add_new_section_link'
    this.$add_new_section_link = $(this.add_new_section_link_id)
    this.$sections = $('.list')
    this.add_new_section_form = this.$add_new_section_link.data('form')
    this.delete_section_button = '[data-modal-target="#delete-section-modal"]'
  }

  setup() {
    const update = (e, ui) => {
      this.$sections.sortable("disable");

      const regex = /(\/admin\/parts\/)(\d+)/g;
      const partId = regex.exec(window.location.pathname)[2]
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
      const data = {create_section: {}}
      $(event.currentTarget).serializeArray().forEach((param) =>{
        const sectionParam = param.name.match(/create_section\[([a-z]+)\]/)
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

    $('body').on('click', this.delete_section_button, (event) => {
      const action = event.currentTarget.dataset.deleteUrl;
      const modal = $(event.currentTarget.dataset.modalTarget)
      modal.find('form').attr('action', action);
      modal.find("[data-section-title]").text(event.currentTarget.dataset.sectionTitle);
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



