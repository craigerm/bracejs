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

    # A helper for fetching models and rendering on success
    fetchAndRender: (model, ViewClass) ->
      self = @
      # Should we return a promise so we can handle the error?
      model.fetch().success -> self.render new ViewClass(model: model)

    # Actions should call this to render
    render: (view) ->
      @dispatcher.handleControllerRender @, view

