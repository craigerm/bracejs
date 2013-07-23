define ['brace'], (Brace) ->

  describe 'router', ->

    describe '#constructor', ->
      it 'has Backbone.Events', ->
        router = new Brace.Router()
        expect(router.trigger).not.toBe(null)
