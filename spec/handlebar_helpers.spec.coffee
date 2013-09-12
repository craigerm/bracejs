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
        context =
          fn: ->
          inverse: ->

        spyOn(context, 'fn')
        spyOn(context, 'inverse')

      it 'executes block for equal values', ->
        Handlebars.helpers.ifequal('hello', 'hello', context)
        expect(context.fn).toHaveBeenCalled()
        expect(context.inverse).not.toHaveBeenCalled()

      it 'executes inverse if values not equal', ->
        Handlebars.helpers.ifequal('hello', 'world', context)
        expect(context.inverse).toHaveBeenCalled()
        expect(context.fn).not.toHaveBeenCalled()

    describe '#default', ->

      it 'returns default if null', ->
        result = Handlebars.helpers.default null, '(none)'
        expect(result).toBe('(none)')

      it 'returns default is empty string', ->
        result = Handlebars.helpers.default '', '(none)'
        expect(result).toBe('(none)')

      it 'returns value if it is a value', ->
        result = Handlebars.helpers.default '500', '(none)'
        expect(result).toBe('500')

    describe '#ifempty', ->

      context = null

      beforeEach ->
        context =
          fn: ->
          inverse: ->

        spyOn(context, 'fn')
        spyOn(context, 'inverse')

      it 'executes block if value is empty', ->
        Handlebars.helpers.ifempty([], context)
        expect(context.fn).toHaveBeenCalled()
        expect(context.inverse).not.toHaveBeenCalled()

      it 'executes inverse if array has a value', ->
        Handlebars.helpers.ifempty([5,4], context)
        expect(context.inverse).toHaveBeenCalled()
        expect(context.fn).not.toHaveBeenCalled()

  describe 'capitalize', ->
    result = Handlebars.helpers.capitalize('hello')
    expect(result).toBe('Hello')

