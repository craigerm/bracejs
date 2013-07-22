define ['brace'], (Brace) ->

  describe 'Util', ->

    Util = Brace.Util

    describe '#pluralize', ->

      it 'adds "s" for common cases', ->
        expect(Util.pluralize('car')).toBe('cars')

      it 'adds "es" for common cases', ->
        expect(Util.pluralize('glass')).toBe('glasses')
        expect(Util.pluralize('potato')).toBe('potatoes')

      it 'changes words ending in "f" to "ves"', ->
        expect(Util.pluralize('half')).toBe('halves')

    describe '#capitalize', ->

      it 'changes the first character', ->
        expect(Util.capitalize('hello')).toBe('Hello')

    describe '#ensure', ->

      it 'throw error if property not on object', ->
        block = -> Util.ensure {}, 'name', 'CustomObj'
        r = expect(block).toThrow(new Error('The value \'name\' must be set on \'CustomObj\''))

    describe '#humanize', ->

      it 'splits and capitalize the words', ->
        expect(Util.humanize('first_name')).toBe('First Name')

      it 'works for one word', ->
        expect(Util.humanize('name')).toBe('Name')


