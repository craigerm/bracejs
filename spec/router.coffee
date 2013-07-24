define ['brace','backbone'], (Brace, Backbone) ->

  describe 'router', ->

    router = null

    beforeEach ->
      routes = ->
      router = new Brace.Router(routes)

    describe '#constructor', ->
      it 'has Backbone.Events', ->
        expect(router.trigger).not.toBe(null)

    describe '#start', ->
      it 'starts backbone router', ->
        expect(Backbone.history._hasPushState).toBeFalsy()
        router.start()
        expect(Backbone.history._hasPushState).toBeTruthy()

    describe '#createResource', ->
      it 'returns info about simple route', ->
        info = router.createResource('users#index')
        expect(info.controller).toBe('users_controller')
        expect(info.action).toBe('index')

    describe '#match', ->
      it 'adds simple route info to map', ->
        router.match('users/new', 'users#create')
        info = router.routeMap['users/new']
        expect(info).toBeDefined()
        expect(info.controller).toBe('users_controller')
        expect(info.action).toBe('create')

