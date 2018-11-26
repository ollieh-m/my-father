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
      const links = section.find(this.link)
      cascade(links, 'up', this.animationSpeed, ()=>{
        section.removeClass('open')
      })
  		$('.arrow.active').removeClass('active')
  	}

  	const openClosedSection = (section) => {
      const links = section.find(this.link)
      cascade(links, 'down', this.animationSpeed, ()=>{
        section.addClass('open')
      })
  		if (section.find(`${this.link}.active`).length > 0) {
				section.find(`${this.link}.active`).parent().siblings('.arrow').addClass('active')
      }
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
        history.pushState({forceReload: true}, null, href);

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

$(document).ready(()=>{
  $(window).on('popstate', ()=>{
    // if we have gone back/forward to a page put in the history by pushState, 
    // force the browser to load the page, because the
    // it has no cached version of the page to display
    const href = window.location.pathname    
    if (history.state.forceReload) {
      window.location.assign(href)
    }
  })
})

$(document).on('turbolinks:load', () => {
  if ($('.js-class-standard-show-section-page').length > 0) {
    const nav = new AnimatedNav()
    nav.setup()
    nav.listen()
  }
})



