$window = $(window)
autoScrolling = false

reachedBottom = ->
  $(window).scrollTop() >= maxScroll()
  
maxScroll = ->
  $(document).height() - $window.height()

updateNavigation = ->
  wHeight = $window.height()
  scrollTop = $window.scrollTop() + $('#header').outerHeight()

  $('section').each ->
    $this = $(this)
    sectionOffsetTop = $this.offset().top

    if (scrollTop >= sectionOffsetTop && scrollTop <= $this.outerHeight() + $this.offset().top || reachedBottom())
      current = if reachedBottom() then 'footer' else $this.attr('id')
      $('.header__navigation-item a').removeClass('active')
      $('.header__navigation-item a[href=#' + current + ']').addClass('active')

$window.on 'scroll', ->
  $this = $(this)
  $body = $('body')
  scrollTop = $this.scrollTop()
  scale = Math.max(1, 1 + (scrollTop / 6000))

  if scrollTop >= 40 then $body.addClass('scrolled') else $body.removeClass('scrolled')
  $('.parallax-bg').css('transform', 'scale(' + scale + ')') if scrollTop <= $('#intro').outerHeight()
  updateNavigation() unless autoScrolling

$('.scroll-to').on 'click', (e) ->
  e.preventDefault()
  $this = $(this)
  target = if $this.attr('href') then $this.attr('href') else $this.data('scroll-to')

  autoScrolling = true
  TweenMax.to window, .7,
    scrollTo:
      y: Math.min(maxScroll(), $(target).offset().top - $('#header').outerHeight() + 1)
      autoKill: false
    onComplete: ->
      updateNavigation()
      autoScrolling = false
