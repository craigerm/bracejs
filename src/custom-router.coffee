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

