import { cascade } from './jquery_plugins'

class AnimatedNav {
  constructor() {
  	this.animationSpeed = 20;
    this.sectionHeader = '.menu__section-header'
    this.linksWithHeader = '.menu__link__with-header'
    this.links = '.menu__link a'
  }

  setup() {
  	const activeNavSection = $(`${this.linksWithHeader}.active`).parent().parent().parent()
  	if (!activeNavSection.hasClass('open')) {
  		cascade(activeNavSection.find(this.linksWithHeader), 'down', this.animationSpeed, ()=>{
  			activeNavSection.addClass('open')
  		})
  	}
  }

  listen() {
  	const closeOpenSection = (section) => {
      const links = section.find(this.linksWithHeader)
      cascade(links, 'up', this.animationSpeed, ()=>{
        section.removeClass('open')
      })
  		$('.arrow.active').removeClass('active')
  	}

  	const openClosedSection = (section) => {
      const links = section.find(this.linksWithHeader)
      cascade(links, 'down', this.animationSpeed, ()=>{
        section.addClass('open')
      })
  		if (section.find(`${this.linksWithHeader}.active`).length > 0) {
				section.find(`${this.linksWithHeader}.active`).parent().siblings('.arrow').addClass('active')
      }
    }
    
    $('body').on('click', this.sectionHeader, (event) => {
      const section = $(event.currentTarget).parents('.menu__section')
      
      if (section.hasClass('open')) {
        closeOpenSection(section)
      } else {
        closeOpenSection($('.menu__section.open').first())
        openClosedSection(section)
      }
    })

    $('body').on('click', this.links, (event) => {
      event.preventDefault()

      const currentLink = $(event.currentTarget)
      const href = currentLink.attr('href')

      $.ajax({
        method: "GET",
        url: href
      }).done((response) => {
        history.pushState({forceLoad: true}, null, href);

        $('.active').removeClass('active')
        currentLink.children('li').addClass('active')
        currentLink.siblings('.arrow').addClass('active')

        const newPage = $(response).find('.text').html()
        $('.text').html(newPage)

        // trigger custom event that we listen to in the page head to trigger a google analytics page load
        document.dispatchEvent(new CustomEvent('animated-nav:load', { detail: {url: window.location.href }}))
      });
    })

  }
}

$(window).on('popstate', ()=>{
  // if we have gone back/forward to a page put in the history by pushState, 
  // force the browser to load the page, because it has no cached version of the page to display
  const href = window.location.pathname    
  if (history.state.forceLoad) {
    window.location.assign(href)
  }
})

$(document).on('turbolinks:load', () => {
  if ($('.js-class-standard-show-section-page').length > 0) {
    const nav = new AnimatedNav()
    nav.setup()
    nav.listen()
  }
})



