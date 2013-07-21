define [
  'spine/util'
  'spine/dispatcher'
  'spine/event-hooks'
  'underscore'
], (util, Dispatcher, EventHooks, _) ->

  class Application

    # Must be overwritten by base class
    routes: null
    defaultLayout: null

    start: ->

      util.ensure @, 'routes', 'Application'
      util.ensure @, 'defaultLayout', 'Application'

      @dispatcher = new Dispatcher(@routes, @defaultLayout)

      # Add any jquery hooks or whatever to handle our backbone approach
      EventHooks.start(@dispatcher.router)

      # Start the dispatcher
      @dispatcher.start()

