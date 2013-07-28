  class Navigator

    constructor: (router) ->
      Contract.present router, 'router must be passed into Navigator'
      @router = router
      _.extend(@, Backbone.Events)

    navigate: (url, options) ->
      if options and options.flash
        @router.pendingFlash =
          message: options.flash
          type: options.type || 'info'

      @router.navigate url

