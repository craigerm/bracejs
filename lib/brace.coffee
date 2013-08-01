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
  'handlebars'
], (_, Backbone, Handlebars) ->

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
      @fail(msg) unless arr && arr.length > 0

    present: (obj, msg) ->
      @fail(msg) unless obj

    fail: (msg) ->
      error = new Error msg
      error.name = 'ContractError'
      throw error





  EventHooks =

    start: (router) ->

      # Handle any links to backbone navigator
      $(document).on 'click', 'a[href^="/"]', (event) ->
        return if event.ctrlKey || event.shiftKey || event.metaKey
        href = $(event.currentTarget).attr('href')
        event.preventDefault()
        url = href.replace(/^\//,'').replace('\#\!\/','')
        router.navigate url, trigger: true

  Handlebars.registerHelper 'json', (obj) ->
    JSON.stringify(obj)

  class Model extends Backbone.Model

  class Navigator

    constructor: (router) ->
      Contract.present router, 'router must be passed into Navigator'
      @router = router
      _.extend(@, Backbone.Events)

    navigate: (url, options) ->
      if options and options.flash
        @router.pendingFlash =
          message: options.flash
          type: options.type || 'info'

      @router.navigate url


  class Controller

    preInitialize: noop
    postInitialize: noop

    constructor: (dispatcher) ->
      Contract.present dispatcher, 'Controller: dispatcher must be passed into constructor'
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
    # Options:
    #   except or only
    beforeFilter: (fn, options) ->
      @beforeFilters.push(fn: fn, options: options)

    navigate: (url, options) ->
      @dispatcher.navigator.navigate(url, options)

    # A helper for fetching models and rendering on success
    fetchAndRender: (model, ViewClass) ->
      self = @
      # Should we return a promise so we can handle the error?
      model.fetch().success -> self.render new ViewClass(model: model)

    # Actions should call this to render
    render: (view) ->
      @dispatcher.handleControllerRender @, view


  # TODO: Refactor this and the CustomRouter into one class. Remove
  # constructor. 
  class Router

    defaultControllerNamespace: 'controllers'

    constructor: (routes, options) ->
      @options = _.extend({}, pushState: true, options)
      _.extend @, Backbone.Events
      @pendingFlash = null
      @routes = routes
      @routeMap = {}

    loadRouteInfo: (route) ->
      route = route.substr(1) if route[0] == '/'
      route = route.substr(0,route.length - 1) if route[route.length - 1] == '/'
      @routeMap[route]

    createResource: (path) ->
      parts = path.split('#')
      name = parts[0] + '_controller'
      paths = name.split('/')
      name = _.last(paths)
      namespace = @defaultControllerNamespace

      if paths.length > 1
        paths.pop()
        namespace = paths.join('/')

      # Return info about this resource
      controller: name
      action: parts[1]
      namespace: namespace

    start: ->
      # Refactor all this nonsense
      self = @

      # A stub class
      RouterClass = Backbone.Router.extend
        routes: {}

      count = 1
      @routes(_.bind @match, @)
      _.each @routeMap, (value, key) ->
        routeHandler = 'routeHandler' + count
        RouterClass.prototype.routes[key] = routeHandler
        RouterClass.prototype[routeHandler] = ->
          self.handleRoute(value, arguments)
        count++

      @backboneRouter = new RouterClass()
      Backbone.history.start(@options)

    handleRoute: (info) ->
      args = Array.prototype.slice.call(arguments, 1)
      @trigger 'route-change', info, args[0]

    match: (route, path) ->
      info = @createResource(path)
      @routeMap[route] = info

    navigate: (url) ->
      @backboneRouter.navigate url, trigger: true


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

    # Append the view
    appendView: (view) ->
      @$el.append(view.render().el)
      @

    renderViewInRegion: (regionName, view) ->
      selector = @regions[regionName]
      region = @$el.find(selector)
      throw new Error "Cannot find region '#{regionName}'" if region.length is 0
      region.html(view.render().el)

    initialize: ->
      @pendingRegionsToRender = []
      @isRendered = false
      @listenTo @, 'remove', @unbindUI
      @assignSpecialOptions()
      @preInitialize()
      @postInitialize()

    assignSpecialOptions: ->
      @layout = @options.layout

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

    bindExtraEvents: ->
      self = @
      # Hack for now just to get behaviour working
      if @onEnterKey
        @$el.find(':input').on 'keypress', (e) ->
          self.onEnterKey(e) if e.which is 13

    render: ->
      @unbindUI()
      @preRender()
      Contract.present @template, 'view:render must have template'

      html = @template
      @$el.html @template(@getViewData())

      @removeDefaultViewEvents()
      @addDefaultViewEvents()
      @renderPendingRegions()
      @bindUI()
      @bindExtraEvents()
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
      @currentLayout.setFlash(flash.message, type: flash.type) if flash
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
      defaults = type: 'info'
      options = $.extend({}, options, defaults)
      flashModel = message: message, type: options.type
      region.html new @flashView(model: flashModel).render().el

    destroy: ->
      @cleanupRegions()

    cleanupRegions: ->
      @regions = @oldRegions


  class Dispatcher

    constructor: (routes, defaultLayout) ->
      _.extend @, Backbone.Events
      @router = new Router(routes)
      @navigator = new Navigator(@router)
      @defaultLayout = defaultLayout
      @layoutManager = new LayoutManager(@navigator)

    start: ->
      @router.on 'route-change', _.bind @handleControllerAction, @
      @router.start()

    handleControllerAction: (info, params) ->
      return @handle404() unless info
      @trigger 'changed-action', info, params
      @executeAction info, params

    handle404: ->
      throw new Error '404 ERROR IN DISPATCHER!'

    getControllerPath: (info) ->
      "#{info.namespace}/#{info.controller}"

    executeAction: (info, params) ->

      dispatcher = @
      controller_path = @getControllerPath(info)

      # Load controller
      require [controller_path], (Controller) ->

        controller = new Controller(dispatcher)
        action = controller[info.action]
        Contract.present action, "Controller must have action defined (#{info.controller}=>#{info.action})"

        # Handle before filters here
        promise = dispatcher.handleBeforeFilters(controller, info.action)

        # After we handled the before filters execute the controller's action
        promise.done -> dispatcher.renderAction(controller, action, params)

    # Render action after all before filters have been executed
    renderAction: (controller, action, params) ->
      action.apply controller, params

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
      # Ok, the filters are a little weird. We might want to make any AJAX calls
      # before we render the view so each filter can return a promise and either call
      # fail or resolve. If you call fail we won't render the view.

      # Get the actions that should be applied for this action
      filters = @getBeforeFiltersForAction(controller.beforeFilters, action)

      # Execute the action as keep the promises
      promises = _.map filters, (filter) -> filter.call(controller, $.Deferred())

      # Return the promise and have the called handle fail() and done()
      return $.when.apply($, promises)


  class Application

    # Must be overwritten by base class
    routes: null

    # We probably dont need a default layout here.
    defaultLayout: null

    start: ->

      Contract.present @routes, 'Application:routes must be set'
      Contract.present @defaultLayout, 'Application:defaultLayout must be set'

      @dispatcher = new Dispatcher(@routes, @defaultLayout)

      # Add any jquery hooks or whatever to handle our backbone approach
      EventHooks.start(@dispatcher.router)

      # Start the dispatcher
      @dispatcher.start()



  # Expose the objects. Will refactor this later
  Brace.Contract = Contract
  Brace.Application = Application
  Brace.Dispatcher = Dispatcher
  Brace.Controller = Controller
  Brace.Util = Util
  Brace.View = View
  Brace.Model = Model
  Brace.Layout = Layout
  Brace.Navigator = Navigator
  Brace.LayoutManager = LayoutManager
  Brace.Router = Router

  Brace
