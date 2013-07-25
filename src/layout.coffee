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
      Contract.present @regions.content, 'Layout must have aat least a "content" region'
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
      throw new Error "Region '#{key}' was not found!" unless selector
      region = @$el.find(selector)
      region.html view.render().el

    setContent: (view) ->
      region = $(@regions.content)
      region.html view.render().el

    setFlash: (message, options) ->
      region = $(@regions.flash)
      throw new Error 'no flash region found!' if region.length == 0
      throw new Error 'no flash view found in subclass' unless @flashView
      model = message: message
      region.html new @flashView(model: model).render().el

    destroy: ->
      @cleanupRegions()

    cleanupRegions: ->
      @regions = @oldRegions

