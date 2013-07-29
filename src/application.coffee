  class Application

    # Must be overwritten by base class
    routes: null

    # We probably dont need a default layout here.
    defaultLayout: null

    start: ->

      Contract.present @routes, 'Application:routes must be set'
      Contract.present @defaultLayout, 'Application:defaultLayout must be set'

      @dispatcher = new Dispatcher(@routes, @defaultLayout)

      # Add any jquery hooks or whatever to handle our backbone approach
      EventHooks.start(@dispatcher.router)

      # Start the dispatcher
      @dispatcher.start()

