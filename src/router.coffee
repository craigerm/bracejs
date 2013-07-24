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
      @customRouter = new CustomRouter()
      @customRouter.on 'route-changed', _.bind @onRouteChange, @
      @routes(_.bind @match, @)
      Backbone.history.start(@options)

    match: (route, path) ->
      info = @createResource(path)
      @routeMap[route] = info

    navigate: (url) ->
      @customRouter.navigate url, trigger: true

