import { cascade } from './jquery_plugins'

class AnimatedNav {
  constructor(element) {
    this.$element = $(element);
  	this.animationSpeed = 20;
    this.sectionHeaderSelector = "[data-animated-nav-target='sectionHeader']"
    this.linksWithHeaderSelector = "[data-animated-nav-target='linkWithHeader']"
    this.linksSelector = "[data-animated-nav-target='link']"
  }

  setup() {
  	const activeNavSection = $(`${this.linksWithHeaderSelector}.active`).parent().parent().parent()
  	if (!activeNavSection.hasClass('open')) {
  		cascade(activeNavSection.find(this.linksWithHeaderSelector), 'down', this.animationSpeed, ()=>{
  			activeNavSection.addClass('open')
  		})
  	}
  }

  listen() {
  	const closeOpenSection = (section) => {
      const links = section.find(this.linksWithHeaderSelector)
      cascade(links, 'up', this.animationSpeed, ()=>{
        section.removeClass('open')
      })
  		$('.arrow.active').removeClass('active')
  	}

  	const openClosedSection = (section) => {
      const links = section.find(this.linksWithHeaderSelector)
      cascade(links, 'down', this.animationSpeed, ()=>{
        section.addClass('open')
      })
  		if (section.find(`${this.linksWithHeaderSelector}.active`).length > 0) {
				section.find(`${this.linksWithHeaderSelector}.active`).parent().siblings('.arrow').addClass('active')
      }
    }
    
    this.$element.on('click', this.sectionHeaderSelector, (event) => {
      const section = $(event.currentTarget).parents('.menu__section')
      
      if (section.hasClass('open')) {
        closeOpenSection(section)
      } else {
        closeOpenSection($('.menu__section.open').first())
        openClosedSection(section)
      }
    })

    this.$element.on('click', this.linksSelector, (event) => {
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

        const newPage = $(response).find('.page').html()
        $('.page').html(newPage)

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
  $("[data-js-component='animatedNav']").each((index, element) => {
    const nav = new AnimatedNav(element)
    nav.setup()
    nav.listen()
  })
})