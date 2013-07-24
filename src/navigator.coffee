  class Navigator

    constructor: (router) ->
      Contract.present router, 'router must be passed into navigator'
      @router = router
      _.extend(@, Backbone.Events)

    navigate: (url, options) ->
      @router.pendingFlash = options.flash if options
      @router.navigate url

