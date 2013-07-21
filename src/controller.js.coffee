define [
], ->

  noop = ->

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

