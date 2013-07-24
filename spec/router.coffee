define ['brace','backbone'], (Brace, Backbone) ->

  describe 'router', ->

    router = null

    beforeEach ->
      Backbone.history.stop()
      routes = ->
      router = new Brace.Router(routes)

    describe '#constructor', ->
      it 'has Backbone.Events', ->
        expect(router.trigger).not.toBe(null)
      it 'builds options with default values', ->
        expect(router.options.pushState).toBe(true)

    describe '#start', ->
      it 'starts backbone router', ->
        Backbone.history.stop()
        expect(Backbone.History.started).toBeFalsy()
        router.start()
        expect(Backbone.History.started).toBeTruthy()

    describe '#createResource', ->
      it 'returns info about simple route', ->
        info = router.createResource('users#index')
        expect(info.controller).toBe('users_controller')
        expect(info.action).toBe('index')

      it 'returns default namespace if not included', ->
        info = router.createResource('users#index')
        expect(info.namespace).toBe('controllers')

      it 'returns namespace if user specified', ->
        info = router.createResource('users/main#index')
        expect(info.controller).toBe('main_controller')
        expect(info.action).toBe('index')
        expect(info.namespace).toBe('users')

    describe '#match', ->
      it 'adds simple route info to map', ->
        router.match('users/new', 'users#create')
        info = router.routeMap['users/new']
        expect(info).toBeDefined()
        expect(info.controller).toBe('users_controller')
        expect(info.action).toBe('create')

