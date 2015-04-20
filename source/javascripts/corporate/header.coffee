class Corporate.Header
  constructor: ->
    @window = $(window)
    @autoScrolling = false
    @sections = []
    @triggerBlueBgOffset = 40
    @headerHeight = $('#header').outerHeight()

    @getSectionsData()
    @bindEvents()

  bindEvents: ->
    @window.scroll @scroll
    @window.resize @getSectionsData
    $('.scroll-to').click @scrollTo

  sectionReachedTop: (section, sectionData) ->
    scrollTopWithHeader = @scrollTop + @headerHeight
    scrollTopWithHeader >= sectionData.offsetTop && scrollTopWithHeader <= sectionData.height + sectionData.offsetTop

  scrollReachedBottom: -> @scrollTop >= @maxScroll()

  maxScroll: -> $(document).height() - @window.height()

  getSectionsData: =>
    $('section, #footer').each (index, section) =>
      $section = $(section)
      @sections[$section.attr('id')] = 
        offsetTop: $section.offset().top
        height: $section.outerHeight()

  updateNavigation: =>
    for section, sectionData of @sections
      if @sectionReachedTop(section, sectionData) || @scrollReachedBottom()
        current = if @scrollReachedBottom() then 'footer' else section
        $('.header__navigation-item a').removeClass('active')
        $('.header__navigation-item a[href=#' + current + ']').addClass('active')

  scroll: =>
    @scrollTop = @window.scrollTop()
    $body = $('body')
    scale = Math.max(1, 1 + (@scrollTop / 6000))

    if @scrollTop >= @triggerBlueBgOffset then $body.addClass('scrolled') else $body.removeClass('scrolled')
    $('.parallax-bg').css('transform', 'scale(' + scale + ')') if @scrollTop <= $('#intro').outerHeight()
    @updateNavigation() unless @autoScrolling

  scrollTo: (e) =>
    e.preventDefault()
    $scrollEl = $(e.currentTarget)
    target = $scrollEl.attr('href') || $scrollEl.data('scroll-to')
    targetOffsetTop = @sections[target.replace('#', '')].offsetTop
    @autoScrolling = true

    TweenMax.to window, .7,
      scrollTo:
        y: Math.min(@maxScroll(), targetOffsetTop - @headerHeight + 1)
        autoKill: false
      onComplete: =>
        @updateNavigation()
        @autoScrolling = false
