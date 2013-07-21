define [
  'backbone'
], (Backbone) ->

  CustomRouter = Backbone.Router.extend(

    initialize: (options) ->
      @spine_router = options.spine_router
      @listenTo @, 'route', @onRouteChange

    routes:
      '*notFound': 'handleRoute'

    onRouteChange: () ->
      # Not sure the best way to get the url
      url = location.pathname #???

      # Not sure if we should do that or the spine router
      @navigate url, trigger: true

      @spine_router.onRouteChange(url)

    handleRoute: ->
      # noop
  )
