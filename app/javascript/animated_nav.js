$.fn.reverse = [].reverse

class AnimatedNav {
  constructor() {
  	this.animationSpeed = 20;
    this.sectionHeader = '.menu__section-header'
  }

  listen() {
  	$('body').on('click', this.sectionHeader, (event) => {
  		$currentActiveSection = $('.menu__section.active')

  		if (!($(event.currentTarget).parent().hasClass('active'))) {
  			// if the selected nav section does not include the active arrow, hide the arrow
  			if ($(event.currentTarget).parent().find('.menu__link__with-header.active').length === 0) {
  				$('.arrow.active').hide()
  			} else {
  				$('.arrow.active').show()
  			}
  			// if you are opening a new nav section, hide the currently active nav section section
  			currentlyActiveLinks = $currentActiveSection.find('.menu__link__with-header').reverse()
  			currentlyActiveLinks.each((index, el) => {
			    setTimeout(() => {
			      $(el).slideUp(this.animationSpeed, 'linear');
			      if (index == currentlyActiveLinks.length - 1) {
			  			$currentActiveSection.removeClass('active')
			      }
			    }, index * this.animationSpeed);
			  })
  			// and open the new nav section section
  			newlyActiveLinks = $(event.currentTarget).parent().find('.menu__link__with-header')
	  		newlyActiveLinks.each((index, el) => {
			    setTimeout(() => {
			      $(el).slideDown(this.animationSpeed, 'linear');
			      if (index == newlyActiveLinks.length - 1) {
			  			$(event.currentTarget).parent().addClass('active')
			      }
			    }, index * this.animationSpeed);
			  })
			}
  	})
  }
}

$(document).on('turbolinks:load', () => {
  const nav = new AnimatedNav()
  nav.listen()
})



