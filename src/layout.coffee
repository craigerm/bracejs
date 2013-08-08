  class Layout extends View

    # must be set
    navigator: null

    # selector of where to put this guy
    container: null

    # Any default views to insert to other content areas
    defaults: null

    render: ->
      @preRender()
      element = $(@container)

      Contract.notEmpty element, "Layout cannot find an element that matches the selector '#{@container}'"
      Contract.present @template, 'Layout must have template'
      Contract.present @regions.content, 'Layout must have at least a "content" region'
      Contract.present @options.navigator, 'Navigator must be set on the layout'

      @renderTemplate()
      @renderRegions()

      @postRender()
      @

    renderTemplate: ->
      @$el.html @template()

    renderRegions: ->
      self = @
      regions = @regions
      _.each @defaults, (ViewClass, regionName) ->
        view = new ViewClass()
        view.layout = self
        view.navigator = self.options.navigator
        self.renderRegion regionName, view

    renderRegion: (key, view) ->
      selector = @regions[key]
      Contract.present selector, "Layout region  '#{key}' was not found"
      region = @$el.find(selector)
      region.html view.render().el

    setContent: (view) ->
      @contentView.remove() if @contentView
      region = $(@regions.content)
      region.html view.render().el
      @contentView = view

    hasFlashRegion: ->
      region = $(@regions.flash)
      region.length > 0

    getFlashRegion: ->
      region = $(@regions.flash)
      Contract.notEmpty region, 'Layout requires a flash region'
      region

    clearFlash: ->
      @getFlashRegion().html '' if @hasFlashRegion()

    setFlash: (message, options) ->
      region = @getFlashRegion()
      Contract.present @flashView, 'Layout requires a flash view'
      defaults = type: 'info'
      options = $.extend {}, defaults, options
      flashModel = message: message, type: options.type
      region.html new @flashView(model: flashModel).render().el

    destroy: ->
      @cleanupRegions()

    cleanupRegions: ->
      @regions = @oldRegions

