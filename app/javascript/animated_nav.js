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
  		$('.arrow.active').removeClass('active')
  		const links = section.find(this.link)
  		cascade(links, 'up', this.animationSpeed, ()=>{
  			section.removeClass('open')
  		})
  	}

  	const openClosedSection = (section) => {
  		if (section.find(`${this.link}.active`).length > 0) {
				section.find(`${this.link}.active`).parent().siblings('.arrow').addClass('active')
			}
  		const links = section.find(this.link)
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

    $('body').on('click', this.link, (event) => {
      event.preventDefault()
      event.stopImmediatePropagation()

      const currentLink = $(event.currentTarget)
      const href = currentLink.parent().attr('href')
      $.ajax({
        method: "GET",
        url: href
      }).done((response) => {
        $('.active').removeClass('active')
        currentLink.addClass('active')
        const arrow = currentLink.parent().siblings('.arrow')
        arrow.addClass('active')

        const newPage = $(response).find('.text').html()
        $('.text').html(newPage)
      });
    })
  }
}

$(document).on('turbolinks:load', () => {
  const nav = new AnimatedNav()
  nav.setup()
  nav.listen()
})



