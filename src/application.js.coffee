class Application

  # Must be overwritten by base class
  routes: null
  defaultLayout: null

  start: ->

    Util.ensure @, 'routes', 'Application'
    Util.ensure @, 'defaultLayout', 'Application'

    @dispatcher = new Dispatcher(@routes, @defaultLayout)

    # Add any jquery hooks or whatever to handle our backbone approach
    EventHooks.start(@dispatcher.router)

    # Start the dispatcher
    @dispatcher.start()

