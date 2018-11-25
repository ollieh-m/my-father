class AnimatedNav {
  constructor() {
  	this.animationSpeed = 50;
    this.activeLink = '.menu__link__with-header.active'
  }

  setup() {
  	initialSection = $(this.activeLink).parent().parent().parent()
  	initialSection.find('.menu__link__with-header').each((index, el) => {
	    setTimeout(() => {
	      $(el).slideDown(this.animationSpeed);
	    }, index * this.animationSpeed);
  	})
  }

  listen() {
    
  }
}

$(document).on('turbolinks:load', () => {
  const nav = new AnimatedNav()
  nav.setup()
  nav.listen()
})



