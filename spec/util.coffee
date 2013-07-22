describe 'Util', ->

  describe '#pluralize', ->

    it 'add an "s" when necessary', ->
      expect(Util.pluralize('car')).toBe('cars')
