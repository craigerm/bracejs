# Brace JS (A backbone framework)
#
# V0.0.1
#
# Copyright (c)2013 Craig MacGregor
# Distributed under MIT license
#
# https://github.com/craigerm/bracejs
define [
  'underscore',
  'backbone',
], (_, Backbone) ->

  Brace = {}
  noop = ->

  $ = Brace.$ = Backbone.$

  Util =

    # Ensures that a key exists on the class. I.e is set
    ensure: (context, key, className) ->
      return if context[key]
      throw new Error("The value '#{key}' must be set on '#{className}'")

    pluralize: (word) ->
      len = word.length
      return word + 'es' if word.match /(o|s)$/i
      return word.substring(0, len - 1)  + 'ves' if word.match /f$/i
      return word + 's'

    # Example change "name" to "Name"
    capitalize: (str) ->
      str.substr(0, 1).toUpperCase() + str.substr(1)

    # Example: change "first_name" to "First Name"
    humanize: (name) ->
      words = _.map name.split('_'), (word) -> Util.capitalize(word)
      return words.join(' ')


  Contract =
    notEmpty: (arr, msg) ->
      return if arr && arr.length > 0
      throw new Error(msg)

    present: (obj, msg) ->
      throw new Error msg unless obj




  EventHooks =

    start: (router) ->

      # Handle any links to backbone navigator
      $(document).on 'click', 'a[href^="/"]', (event) ->
        href = $(event.currentTarget).attr('href')
        event.preventDefault()
        url = href.replace(/^\//,'').replace('\#\!\/','')
        router.navigate url, trigger: true

  class Model extends Backbone.Model

  class Navigator

    constructor: (router) ->
      Contract.present router, 'router must be passed into navigator'
      @router = router
      _.extend(@, Backbone.Events)

    navigate: (url, options) ->
      @router.pendingFlash = options.flash if options
      @router.navigate url


  CustomRouter = Backbone.Router.extend

    initialize: ->
      @listenTo @, 'route', @onRouteChange

    routes:
      '*notFound': 'handleRoute'

    onRouteChange: (name, route)->

      # Not sure the best way to get the url
      # This needs to be reworked.
      url = location.pathname
      if route and route[0]
        url = route[0]

      # Not sure if we should do that or the brace router
      #@navigate url, trigger: true
      console.log 'triggering route-changed %s', url
      @trigger 'route-changed', url

    handleRoute: ->
      # noop


  class Controller

    preInitialize: noop
    postInitialize: noop

    constructor: (dispatcher, navigator) ->
      throw new Error 'dispatcher is null!! in controller!' unless dispatcher?
      @dispatcher = dispatcher
      @beforeFilters = []
      @initialize()

    navigate: (url, options) ->
      @dispatcher.navigator.navigate url, options

    initialize: ->
      @preInitialize()
      @postInitialize()

    # Example:
    #   @beforeFilter @authenticate, except: ['login']
    beforeFilter: (fn, options) ->
      @beforeFilters.push(fn: fn, options: options)

    navigate: (url, options) ->
      @dispatcher.navigator.navigate(url, options)

    # Actions should call this to render
    render: (view) ->
      @dispatcher.handleControllerRender @, view


  # TODO: Refactor this and the CustomRouter into one class. Remove
  # constructor. 
  class Router

    constructor: (routes, options) ->
      @options = _.extend({}, pushState: true, options)
      _.extend @, Backbone.Events
      @pendingFlash = null
      @routes = routes
      @routeMap = {}

    onRouteChange: (route) ->
      console.log 'Router:onRouteChange = %', route
      info = @loadRouteInfo(route)
      @trigger 'route-change', info

    loadRouteInfo: (route) ->
      route = route.substr(1) if route[0] == '/'
      route = route.substr(0,route.length - 1) if route[route.length - 1] == '/'
      @routeMap[route]

    createResource: (path) ->
      parts = path.split('#')
      name = parts[0] + '_controller'
      controller: name, action: parts[1]

    start: ->
      @customRouter = new CustomRouter()
      @customRouter.on 'route-changed', _.bind @onRouteChange, @
      @routes(_.bind @match, @)
      Backbone.history.start(@options)

    match: (route, path) ->
      info = @createResource(path)
      @routeMap[route] = info

    navigate: (url) ->
      @customRouter.navigate url, trigger: true


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
      @unbindUI()
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
      return unless @originalUI
      @ui = @originalUI
      @originalUI = undefined

    bindUI: ->
      return unless @ui
      @originalUI = @ui
      @ui = {}
      self = @
      _.each @originalUI, (selector, key) ->
        self.ui[key] = self.$el.find(selector)

    # Refactor to mixins
    destroyAfter: (ms) ->
      self = @
      window.setTimeout ->
        self.remove()
      , ms


  class LayoutManager

    constructor: (navigator) ->
      throw new Error 'navigator must be defined on layout manager' unless navigator
      @navigator = navigator

    currentLayout: null

    renderContent: (view, layout) ->

      # We only render the layout if we have to
      if @shouldRenderLayout(@currentLayout, layout)
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
      Math.random() * 99999

    # Refactor this out we can can create a view from a raw html fragment
    makeContentView: (html) ->
      ContentView = Backbone.View.extend
        render: ->
          @$el.html(html)
          @$el
      new ContentView()

    shouldRenderLayout: (currentLayout, LayoutType) ->

      # If no layout is currently set we should render
      return true unless currentLayout

      # If the new layout doesn't have a hash code we know we haven't processed
      # it yet so we should render it because we know it is different.
      if !LayoutType.prototype.__hashCode?
        return true

      return currentLayout.__hashCode != LayoutType.prototype.__hashCode

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

      Contract.notEmpty element, 'Layout cannot find the selector'
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


  class Dispatcher

    constructor: (routes, defaultLayout) ->
      @router = new Router(routes)
      @navigator = new Navigator(@router)
      @defaultLayout = defaultLayout
      @layoutManager = new LayoutManager(@navigator)

    start: ->
      @router.on 'route-change', _.bind @handleControllerAction, @
      @router.start()

    handleControllerAction: (info) ->
      return @handle404() unless info
      @executeAction info

    handle404: ->
      throw new Error '404 ERROR IN DISPATCHER!'

    getControllerPath: (controller_name) ->
      "controllers/#{controller_name}"

    executeAction: (info) ->

      dispatcher = @
      controller_path = @getControllerPath(info.controller)

      # Load controller
      require [controller_path], (Controller) ->

        console.log 'FOUND CONTROLLER %s', info.controller

        # Create controller instance
        controller = new Controller(dispatcher)
        action = controller[info.action]
        throw new Error("CONTROLLER IS MISSING ACTION #{info.controller}=>#{info.action}") unless action

        # Handle before filters here
        promise = dispatcher.handleBeforeFilters(controller, info.action)

        # After we handled the before filters execute the controller's action
        promise.done -> dispatcher.renderAction(controller, action)

    # Render action after all before filters have been executed
    renderAction: (controller, action) ->
      action.call controller

    getLayout: (controller) ->
      # Later we will check the controller for a layout
      return controller.layout || @defaultLayout

    handleControllerRender: (controller, view) ->
      # We need the router here too
      #view.navigator = new Navigator(@router)
      @layoutManager.renderContent(view, @getLayout(controller))

    getBeforeFiltersForAction: (beforeFilters, action) ->
      # Later we can add except, only options
      filters = _.map beforeFilters, (filter) -> filter.fn

    # An example filter:
    #  var deferred = $.Deferred()
    #  deferred.resolve() or deferred.fail() in a callback
    #  return deferred.promise()
    handleBeforeFilters: (controller, action) ->
      # Ok, the filters are a little weird. WE might want to make any AJAX calls
      # before we render the view so each filter can return a promise and either call
      # fail or resolve. If you call fail we won't render the view
      # Get the actions that should be applied for this action
      filters = @getBeforeFiltersForAction(controller.beforeFilters, action)

      # Execute the action as keep the promises
      promises = _.map filters, (filter) -> filter.call(controller)

      # Return the promise and have the called handle fail() and done()
      return $.when.apply($, promises)


  class Application

    # Must be overwritten by base class
    routes: null

    # We probably dont need a default layout here.
    defaultLayout: null

    start: ->

      Util.ensure @, 'routes', 'Application'
      Util.ensure @, 'defaultLayout', 'Application'

      @dispatcher = new Dispatcher(@routes, @defaultLayout)

      # Add any jquery hooks or whatever to handle our backbone approach
      EventHooks.start(@dispatcher.router)

      # Start the dispatcher
      @dispatcher.start()



  # Expose the objects. Will refactor this later
  Brace.Contract = Contract
  Brace.Application = Application
  Brace.Controller = Controller
  Brace.Util = Util
  Brace.View = View
  Brace.Model = Model
  Brace.Layout = Layout
  Brace.Navigator = Navigator
  Brace.LayoutManager = LayoutManager
  Brace.Router = Router
  Brace.CustomRouter = CustomRouter

  Brace
