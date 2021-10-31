import { cascade } from './jquery_plugins'

class AnimatedNav {
  constructor(element) {
    this.$element = $(element);
  	this.animationSpeed = 10;
    this.sectionSelector = "[data-animated-nav-target~='section']"
    this.itemSelector = "[data-animated-nav-target~='item']"
    this.sectionHeaderSelector = "[data-animated-nav-target~='sectionHeader']"
    this.itemWithHeaderSelector = "[data-animated-nav-target~='itemWithHeader']"
  }

  loadPage(event) {
    event.preventDefault()

    const currentLink = $(event.currentTarget).closest('a')
    const href = currentLink.attr('href')

    $.ajax({
      method: "GET",
      url: href
    }).done((response) => {
      history.pushState({forceLoad: true}, null, href);

      $('.active').removeClass('active')
      currentLink.parents(this.itemSelector).addClass('active')

      const newPage = $(response).find('.page').html()
      $('.page').html(newPage)

      // trigger custom event that we listen to in the page head to trigger a google analytics page load
      document.dispatchEvent(new CustomEvent('animated-nav:load', { detail: {url: window.location.href }}))
    });
  }

  closeOpenSection(section, callback) {
    $('.active').removeClass('active')

    const links = section.find(this.itemWithHeaderSelector)
    cascade(links, 'up', this.animationSpeed, ()=>{
      section.removeClass('open')
      
      if (callback) {
        callback()
      }
    })
  }

  openClosedSection(section, callback) {
    const links = section.find(this.itemWithHeaderSelector)
    cascade(links, 'down', this.animationSpeed, ()=>{
      section.addClass('open')

      if (callback) {
        callback()
      }
    })
  }

  setup() {
  	const activeNavSection = $('.active').parents(this.sectionSelector)
  	
    if (!activeNavSection.hasClass('open')) {
      this.openClosedSection(activeNavSection)
  	}
  }

  listen() {    
    this.$element.on('click', this.sectionHeaderSelector, (event) => {
      event.preventDefault()

      const section = $(event.currentTarget).parents(this.sectionSelector)
      
      if (!section.hasClass('open')) {
        this.closeOpenSection($(`${this.sectionSelector}.open`).first(), () => {
          this.openClosedSection(section, () => {
            this.loadPage(event)
          })
        })
      } else {
        this.loadPage(event)
      }
    })

    this.$element.on('click', this.itemWithHeaderSelector, (event) => {
      this.loadPage(event)
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