$(window).on 'scroll', ->
  $this = $(this)
  $body = $('body')

  scrollTop = $this.scrollTop()
  scale = Math.max(1, 1 + (scrollTop / 6000))

  if (scrollTop >= 40)
    $body.addClass('scrolled')
  else
    $body.removeClass('scrolled')

  if (scrollTop <= $('#intro').outerHeight())
    $('.parallax-bg').css('transform', 'scale(' + scale + ')')
