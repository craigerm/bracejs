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

      it 'returns true for equal values', ->
        result = Handlebars.helpers.ifequal('hello', 'hello')
        expect(result).toBe(true)

      it 'returns false if values are different', ->
        result = Handlebars.helpers.ifequal('hello', 'world')
        expect(result).toBe(false)


