define ['brace'], (Brace) ->

  describe 'Controller', ->

    Controller = Brace.Controller
    dispatch = {}

    describe '#constructor', ->

      it 'throws error if no dispatcer passed in', ->
        expect(-> new Controller()).toThrow(new Error('Controller: dispatcher must be passed into constructor'))

      it 'sets before filters to empty array', ->
        expect(new Controller(dispatch).beforeFilters.length).toBe(0)

      it 'calls initialize pipeline', ->
        spyOn(Controller.prototype, 'initialize').andCallThrough()
        spyOn(Controller.prototype, 'preInitialize')
        spyOn(Controller.prototype, 'postInitialize')
        controller = new Controller(dispatch)

        expect(controller.initialize).toHaveBeenCalled()
        expect(controller.preInitialize).toHaveBeenCalled()
        expect(controller.postInitialize).toHaveBeenCalled()

