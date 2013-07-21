define [
  'spine/router'
  'spine/layout-manager'
  'spine/navigator'
  'underscore'
  'jquery'
], (Router, LayoutManager, Navigator, _, $)->

  class Dispatcher

    constructor: (routes, defaultLayout) ->
      @router = new Router(routes)
      @navigator = new Navigator(@router)
      @defaultLayout = defaultLayout
      @layoutManager = new LayoutManager(@navigator)

    start: ->
      @router.on 'route-change', _.bind @handleControllerAction, @
      @router.start()

    handleControllerAction: (info) ->
      return @handle404() unless info
      @executeAction info

    handle404: ->
      console.log '404: Route not found!!'
      throw new Error '404 ERROR IN DISPATCHER!'

    getControllerPath: (controller_name) ->
      "controllers/#{controller_name}"

    executeAction: (info) ->

      dispatcher = @
      controller_path = @getControllerPath(info.controller)

      # Load controller
      require [controller_path], (Controller) ->

        console.log 'FOUND CONTROLLER %s', info.controller

        # Create controller instance
        controller = new Controller(dispatcher)
        action = controller[info.action]
        throw new Error("CONTROLLER IS MISSING ACTION #{info.controller}=>#{info.action}") unless action

        # Handle before filters here
        promise = dispatcher.handleBeforeFilters(controller, info.action)

        # After we handled the before filters execute the controller's action
        promise.done -> dispatcher.renderAction(controller, action)

    # Render action after all before filters have been executed
    renderAction: (controller, action) ->
      action.call controller

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
      # Ok, the filters are a little weird. WE might want to make any AJAX calls
      # before we render the view so each filter can return a promise and either call
      # fail or resolve. If you call fail we won't render the view
      # Get the actions that should be applied for this action
      filters = @getBeforeFiltersForAction(controller.beforeFilters, action)

      # Execute the action as keep the promises
      promises = _.map filters, (filter) -> filter.call(controller)

      # Return the promise and have the called handle fail() and done()
      return $.when.apply($, promises)

