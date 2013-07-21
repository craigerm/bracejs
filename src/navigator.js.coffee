  class Navigator

    constructor: (router) ->
      throw new Error 'router must be passed into navigator' unless router
      @router = router
      _.extend(@, Backbone.Events)

    navigate: (url, options) ->
      #if options.flash
      #  @trigger 'flash', options
      @router.pendingFlash = options.flash if options
      @router.customRouter.navigate url, trigger: true

