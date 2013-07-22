  class View extends Backbone.View

    navigator: null

    regions: {}

    ensureAtLeastOne: (key) ->
      arr = @[key]
      return if arr and arr.length > 0
      throw new Error "'#{key}' must have at 1 value in the array and cannot be null!"

    # Helper
    ensure: (key) ->
      throw new Error "'#{key}' must be defined in base form view!" unless @[key]

    # These can be overwritten
    preInitialize: noop
    postInitialize: noop
    preRender: noop
    postRender: noop

    # Set a view to region
    setView: (region, view) ->
      @renderViewInRegion(region, view) if @isRendered
      @pendingRegionsToRender.push(region: region, view: view) unless @isRendered

    renderViewInRegion: (regionName, view) ->
      selector = @regions[regionName]
      region = @$el.find(selector)
      throw new Error "Cannot find region '#{regionName}'" if region.length is 0
      region.html(view.render().el)

    initialize: ->
      @pendingRegionsToRender = []
      @isRendered = false
      @listenTo @, 'remove', @unbindUI
      @preInitialize()
      @postInitialize()

    flash: (message, options) ->
      @layout.setFlash(message, options)

    getViewData: ->
      return @model.attributes if @model && @model.attributes
      return @model if @model
      return @collection.attributes if @collection && @collection.attributes
      return @collection if @collection
      {}

    renderPendingRegions: ->
      view = @
      _.each @pendingRegionsToRender, (item) ->
        view.renderViewInRegion(item.region, item.view)

    cleanup: ->
      @removeDefaultViewEvents()

    removeDefaultViewEvents: ->
      @$el.off 'click', '[data-action]'

    addDefaultViewEvents: ->
      self = @

      # Handle clicks for actions
      @$el.on 'click', '[data-action]', (event) ->
        event.preventDefault()
        event.stopPropagation()
        action = $(event.currentTarget).data('action')
        return if $(event.currentTarget).is('.disabled')
        name = 'onClick' + Util.capitalize(action)
        handler = self[name]
        throw new Error "A handler must be defined in view named '#{name}'" unless handler
        handler.call(self, event)

    navigate: (url, options) ->
      @layout.options.navigator.navigate(url, options)

    render: ->

      @preRender()
      throw new Error 'TEMPLATE MUST BE DEFINED IN VIEW' unless @template

      html = @template
      @$el.html @template(@getViewData())

      @removeDefaultViewEvents()
      @addDefaultViewEvents()
      @renderPendingRegions()
      @bindUI()
      @isRendered = true
      @postRender()
      @

    unbindUI: ->
      console.log 'unbindUI!!'
      @ui = @originalUI

    # UI SEEMS TO BE BROKEN!!!
    bindUI: ->
      @ui = @originalUI if @originalUI?
      @originalUI = @ui
      self = @
      _.each @ui, (selector, key) ->
        console.log 'SETTING KEY=%s => %s', key, selector
        self.ui[key] = self.$el.find(selector)

    destroyAfter: (ms) ->
      self = @
      window.setTimeout ->
        self.remove()
      , ms

