###
maternitypants - giving your textareas some room to grow (or let go) since 2012
Author: Jeff Bordogna, @jeffthink
Version: 0.1 (maybe stable?)
License: See https://github.com/jeffthink/jmaternitypants
###
$ ->
  $.maternitypants = (element, options) ->
    #plugin defaults
    @defaults =
      event: 'dblclick' #on what event to trigger editable
      expandable: true #whether to make the textarea expandable or not
      name: 'value' #textarea name
      onBlurAction: 'cancel' #on blur, 'submit'/'cancel' (save new val/revert)
      forceSubmit: false #if false, won't apply submit cb if no content change
      transformMode: null #e.g. 'line-break' will auto-apply/remove <br>
      onTransformEdit: null #custom transform method when entering editing mode
      onTransformSubmit: null #custom transform method when leaving editing mode
      onSubmit: null #on submit callback

    # css properties that we will clone if we need to expand textarea (any prop
    # that affects sizing, but isn't required part of expandable functionality
    # - see makeExpandable method below
    # TODO better way to clone relevant css props?
    @cloneCSSProperties = [
      'lineHeight', 'textDecoration', 'letterSpacing',
      'fontSize', 'fontFamily', 'fontStyle',
      'fontWeight', 'textTransform', 'textAlign',
      'direction', 'wordSpacing', 'fontSizeAdjust',
      'wordWrap', 'word-break',
      'borderLeftWidth', 'borderRightWidth',
      'borderTopWidth','borderBottomWidth',
      'paddingLeft', 'paddingRight',
      'paddingTop','paddingBottom',
      'marginLeft', 'marginRight',
      'marginTop','marginBottom',
      'boxSizing', 'webkitBoxSizing', 'mozBoxSizing', 'msBoxSizing'
    ]

    # plugin settings
    @settings = {}

    # jQuery version of DOM element attached to the plugin
    @$element = $(element)

    # Private methods

    # bind our edit function to whatever event the user has selected
    bindEvent = =>
      @$element.bind @settings.event, editFn

    # save current content in case we need to revert, then make editable
    editFn = =>
      @revertVal = @$element.html()
      @$element.html ''
      createForm()

    # create textarea, set content to what was there before, add
    # listeners, and make expandable if desired
    createForm = =>
      input = $('<textarea />')
      input.attr 'name', @settings.name
      input.val getContent()
      @$element.append input
      applyKeyListeners(input)
      applyMouseListeners(input)
      makeExpandable(input) if @settings.expandable
      input.focus()

    # set up key listeners - for now, on escape, reset the
    # content to previous value
    applyKeyListeners = (input) ->
      input.keydown (e) ->
        if e.keyCode is 27
          e.preventDefault()
          reset()

    # set up mouse listeners - for now,
    # on blur (when user unfocuses/clicks out), either
    # submit or revert based on settings
    applyMouseListeners = (input) =>
      input.blur (e) =>
        if @settings.onBlurAction is 'cancel'
          reset()
        else if @settings.onBlurAction is 'submit'
          submit(input)

    # Use technique from:
    # http://www.alistapart.com/articles/expanding-text-areas-made-elegant/
    # basically, makes textarea absolutely positioned to not take up space,
    # and creates a pre (preformatted) html tag with the exact same styling.
    # Since this can grow, and textarea has height/width of 100%, textarea
    # takes up same space as pre tag
    makeExpandable = (input) =>
      input.css
        position: 'absolute'
        overflow: 'hidden'
        width: '100%'
        height: '100%'
      container = input.wrap('<div></div>').parent().css position: 'relative'
      input.after('<pre><span></span><br></pre>')
      pre = container.find('pre').css
        visibility: 'hidden'
        whiteSpace: 'pre-wrap'

      # cloning textarea css to pre tag css only if different
      $.each @cloneCSSProperties, (i, p) ->
        val = input.css(p)
        pre.css(p, val) unless pre.css(p) is val
        null

      # when content changes, trigger resize event
      input.bind 'input propertychange keyup', (e) ->
        resize($(e.target))

      # trigger resize event on initial load
      resize(input)

    # get current html for use in text area and if
    # a transform function present, apply that first (
    # useful for line breaks, stripping out html, etc.)
    getContent = =>
      @settings.onTransformEdit?(@revertVal) or @revertVal

    # submit the current textarea value, only if not equal to original
    # value (or if forceSubmit set to true)
    submit = (input) =>
      val = @settings.onTransformSubmit?(input.val()) or input.val()
      @$element.html val

      if val isnt @revertVal or @settings.forceSubmit
        @settings.onSubmit?(val)

    # reset the editable (revert back to previous value and remove textarea)
    reset = =>
      @$element.html @revertVal

    # resize the textarea by taking the textarea text and applying it to the
    # pre tag which has influences the parent size
    resize = (input) ->
      input.parent().children('pre').children('span').html(input.val())

    # set up some common transform methods using transformMode
    setDefaultTransformFns = =>
      if @settings.transformMode is 'line-break'
        unless @settings.onTransformEdit
          @settings.onTransformEdit = lineBreakEditTransform
        unless @settings.onTransformSubmit
          @settings.onTransformSubmit = lineBreakSubmitTransform

    # convert br tag to line break for editing
    lineBreakEditTransform = (val) ->
      val.replace(/<br>/g, '\n')

    # convert line break back to br tag for viewing
    lineBreakSubmitTransform = (val) ->
      val.replace /\n/g, '<br>'

    # Public Methods

    # initialize the plugin by merging passed in options
    # into defaults, setting up other defaults, and calling
    # the main bindEvent function that will handle editing
    # behavior
    @init = ->
      @settings = $.extend {}, @defaults, options
      setDefaultTransformFns()
      bindEvent()

    @init()

  $.fn.maternitypants = (options) ->
    this.each ->
      unless $(this).data 'maternitypants'
        maternitypants = new $.maternitypants this, options
        $(this).data 'maternitypants', maternitypants
