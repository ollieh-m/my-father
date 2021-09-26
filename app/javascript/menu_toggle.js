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

      $(this.menuSelector).addClass("off-screen-left")
      $(this.contentSelector).addClass("full-screen")

      $(this.menuSelector).removeClass("on-screen-left")
      $(this.contentSelector).removeClass("padded-left")

      makeActive($(this.showSelector))
    })

    this.$element.on("click", this.showButtonSelector, () => {
      makeInactive($(this.showSelector))

      $(this.menuSelector).addClass("on-screen-left")
      $(this.contentSelector).addClass("padded-left")

      $(this.menuSelector).removeClass("off-screen-left")
      $(this.contentSelector).removeClass("full-screen")

      makeActive($(this.hideSelector))
    })
  }
}

$(document).on('turbolinks:load', () => {
  $("[data-js-component='menuToggle']").each((index, element) => {
    const toggle = new MenuToggle(element)
    toggle.listen()
  })
})