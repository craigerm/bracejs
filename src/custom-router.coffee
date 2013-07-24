  CustomRouter = Backbone.Router.extend

    initialize: (options) ->
      @brace_router = options.brace_router
      @listenTo @, 'route', @onRouteChange

    routes:
      '*notFound': 'handleRoute'

    onRouteChange: () ->
      # Not sure the best way to get the url
      url = location.pathname #???

      # Not sure if we should do that or the spine router
      @navigate url, trigger: true

      @brace_router.onRouteChange(url)

    handleRoute: ->
      # noop

