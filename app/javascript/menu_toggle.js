class MenuToggle {
  constructor(element) {
    this.$element = $(element);
    this.menuSelector = "[data-menu-toggle-target='menu']"
    this.contentSelector = "[data-menu-toggle-target='content']"
    this.hideSelector = "[data-menu-toggle-target='hide']"
    this.hideButtonSelector = "[data-menu-toggle-target='hideButton']"
    this.showSelector = "[data-menu-toggle-target='show']"
    this.showButtonSelector = "[data-menu-toggle-target='showButton']"
  }

  listen() {
    const makeActive = (element) => {
      element.addClass("menu-toggle--active")
      element.removeClass("menu-toggle--inactive")
    }

    const makeInactive = (element) => {
      element.addClass("menu-toggle--inactive")
      element.removeClass("menu-toggle--active")
    }

    this.$element.on("click", this.hideButtonSelector, () => {
      makeInactive($(this.hideSelector))

      $(this.menuSelector).animate({"margin-left": "-300"}, 500)
      $(this.contentSelector).animate({"padding-left": 0}, 500, () => {
        makeActive($(this.showSelector))
      })
    })

    this.$element.on("click", this.showButtonSelector, () => {
      makeInactive($(this.showSelector))

      $(this.menuSelector).animate({"margin-left": 0}, 500)
      $(this.contentSelector).animate({"padding-left": "300"}, 500, () => {
        makeActive($(this.hideSelector))
      })
    })
  }
}

$(document).on('turbolinks:load', () => {
  $("[data-js-component='menuToggle']").each((index, element) => {
    const toggle = new MenuToggle(element)
    toggle.setup()
    toggle.listen()
  })
})