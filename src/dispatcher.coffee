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

