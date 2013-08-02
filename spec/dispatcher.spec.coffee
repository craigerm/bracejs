define ['brace'], (Brace) ->

  dispatcher = new Brace.Dispatcher()

  describe 'Dispatcher', ->

    describe '#getControllerPath', ->

      it 'return path with namespace', ->
        path = dispatcher.getControllerPath(controller: 'users_controller', namespace: 'home_module')
        expect(path).toBe('home_module/users_controller')
