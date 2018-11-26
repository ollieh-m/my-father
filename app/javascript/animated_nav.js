import { cascade } from './jquery_plugins'

class AnimatedNav {
  constructor() {
  	this.animationSpeed = 20;
    this.sectionHeader = '.menu__section-header'
    this.link = '.menu__link__with-header'
  }

  setup() {
  	const activeNavSection = $(`${this.link}.active`).parent().parent().parent()
  	if (!activeNavSection.hasClass('open')) {
  		cascade(activeNavSection.find(this.link), 'down', this.animationSpeed, ()=>{
  			activeNavSection.addClass('open')
  		})
  	}
  }

  listen() {
  	const closeOpenSection = (section) => {
  		$('.arrow.active').hide()
  		const links = section.find('.menu__link__with-header')
  		cascade(links, 'up', this.animationSpeed, ()=>{
  			section.removeClass('open')
  		})
  	}

  	const openClosedSection = (section) => {
  		if (section.find('.menu__link__with-header.active').length > 0) {
				$('.arrow.active').show()
			}
  		const links = section.find('.menu__link__with-header')
  		cascade(links, 'down', this.animationSpeed, ()=>{
	  		section.addClass('open')
	  	})
  	}
  	
  	$('body').on('click', this.sectionHeader, (event) => {
  		const section = $(event.currentTarget).parent()
  		
  		if (section.hasClass('open')) {
  			closeOpenSection(section)
	  	} else {
	  		closeOpenSection($('.menu__section.open').first())
	  		openClosedSection(section)
	  	}
  	})
  }
}

$(document).on('turbolinks:load', () => {
  const nav = new AnimatedNav()
  nav.setup()
  nav.listen()
})



