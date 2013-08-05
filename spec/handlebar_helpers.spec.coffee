define ['brace', 'handlebars'], (Brace, Handlebars) ->

  describe 'Handlebars helpers', ->

    describe '#json', ->

      it 'should have json helper', ->
        expect(Handlebars.helpers.json).toBeDefined()

      it 'stringifies object', ->
        str = Handlebars.helpers.json(name: 'hello')
        expect(str).toBe('{"name":"hello"}')

      it 'works with null object', ->
        str = Handlebars.helpers.json(null)
        expect(str).toBe('null')

    describe '#ifequal', ->

      context = null

      beforeEach ->
        context = fn: ->
        spyOn(context, 'fn')

      it 'executes block for equal values', ->
        Handlebars.helpers.ifequal('hello', 'hello', context)
        expect(context.fn).toHaveBeenCalled()

      it 'returns false if values are different', ->
        Handlebars.helpers.ifequal('hello', 'world', context)
        expect(context.fn).not.toHaveBeenCalled()

