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

