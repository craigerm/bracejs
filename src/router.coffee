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
      throw new Error 'We only support 1 level of paths for controllers' if paths.length > 2
      namespace = paths[0] unless paths.length is 1
      namespace = @defaultControllerNamespace if paths.length is 1

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
      @customRouter.navigate url, trigger: true

