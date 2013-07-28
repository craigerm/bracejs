define ['brace'], (Brace) ->

  Navigator = Brace.Navigator
  stubRouter = navigate: ->
  navigator = null
  
  describe 'navigator', ->

    beforeEach ->
      navigator = new Navigator(stubRouter)

    describe '#constructor', ->
      block = -> new Navigator()
      expect(block).toThrow(new Error('router must be passed into Navigator'))

    describe '#navigate with flash', ->
      it 'saves pending flash to router', ->
        navigator.navigate '/home', flash: 'flash is working'
        expect(navigator.router.pendingFlash.message).toBe('flash is working')

      it 'sets default type to info', ->
        navigator.navigate '/dashboard', flash: 'you are already logged in'
        expect(navigator.router.pendingFlash.type).toBe('info')

      it 'can set the flash type', ->
        navigator.navigate '/home', flash: 'hello world', type: 'error'
        expect(navigator.router.pendingFlash.type).toBe('error')

