class Corporate.Footer
  constructor: ->
    @footerLogo = $('.footer__logo')

    @animateLogo()

  animateLogo: ->
    @footerLogo.appear()
      .on 'appear', (e, $all_appeared_elements) =>
        @footerLogo.removeClass('hidden')
      .on 'disappear', (e, $all_disappeared_elements) =>
        @footerLogo.addClass('hidden')
