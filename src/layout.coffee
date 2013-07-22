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

      throw new Error "Layout cannot find the selector '#{@container}'" if element.length == 0
      throw new Error "Layout must have template!" unless @template
      throw new Error "Layout must have at least a 'content' region!" unless @regions.content
      throw new Error "Navigator must be set on layout" unless @options.navigator

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

