  class Router extends Backbone.Events


    constructor: (routes, defaultLayout) ->
      _.extend @, Backbone.Events
      @pendingFlash = null
      @routes = routes
      @routeMap = {}

    handleRoute: (a,b,c,d) ->

    onRouteChange: (route) ->
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
      @customRouter = new CustomRouter(spine_router: @)
      @routes(_.bind @match, @)
      Backbone.history.start(pushState: true)

    match: (route, path) ->
      info = @createResource(path)
      @routeMap[route] = info
      #console.log 'mapping "%s" to => %s#%s', route, info.controller, info.action

