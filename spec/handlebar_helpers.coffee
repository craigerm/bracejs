define ['brace', 'handlebars'], (Brace, Handlebars) ->

  describe 'Handlebars helpers', ->

    it 'should have json helper', ->
      expect(Handlebars.helpers.json).toBeDefined()

    it 'stringifies object', ->
      str = Handlebars.helpers.json(name: 'hello')
      expect(str).toBe('{"name":"hello"}')

    it 'works with null object', ->
      str = Handlebars.helpers.json(null)
      expect(str).toBe('null')


