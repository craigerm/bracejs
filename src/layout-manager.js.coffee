define [
  'jquery'
  'backbone'
], ($, Backbone) ->

  # To see if the layout is different maybe we can has the template layout to
  # create a unique ID?
  class LayoutManager

    constructor: (navigator) ->
      throw new Error 'navigator must be defined on layout manager' unless navigator
      @navigator = navigator

    currentLayout: null

    postRender: ->
      console.log '******* POST RENDER LAYOUT *******'

    renderContent: (view, layout) ->

      # We only render the layout if we have to
      if @shouldRenderLayout(@currentLayout, layout)
        console.log '**** RENDERING A NEW LAYOUT ******'
        @currentLayout = @renderLayout(layout)
        @currentLayout.constructor.prototype.__hashCode = @createUniqueID(@currentLayout)
    
      # IF we are trying to render just a string then make a view out of it
      if typeof(view) is 'string'
        view = @makeContentView(view)

      # We need all views to belong to a layout
      view.layout = @currentLayout

      # Render the view in the content area
      @currentLayout.setContent(view)

      # Display any pending flashes after we transition views
      flash = @navigator.router.pendingFlash
      @currentLayout.setFlash(flash) if flash
      @navigator.router.pendingFlash = null

    renderLayout: (LayoutClass) ->
      layout = new LayoutClass(navigator: @navigator)
      el = layout.render().el
      container = $(layout.container)
      throw new Error "Template container could not be found" unless container.length > 0
      container.html(el)
      layout

    createUniqueID: (layout) ->
      # For now return a random number
      Math.random() * 9999999999

    # Refactor this out we can can create a view from a raw html fragment
    makeContentView: (html) ->
      ContentView = Backbone.View.extend
        render: ->
          @$el.html(html)
          @$el
      new ContentView()

    shouldRenderLayout: (currentLayout, newLayout) ->

      # If no layout is currently set we should render
      return true unless currentLayout

      # If the new layout doesn't have a hash code we know we haven't processed
      # it yet so we should render it because we know it is different.
      if !newLayout.prototype.__hashCode?
        return true

      return @currentLayout.__hashCode != newLayout.prototype.__hashCode
