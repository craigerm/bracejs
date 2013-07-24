define ['brace'], (Brace) ->

  Contract = Brace.Contract

  describe 'Contract', ->
    describe '#notEmpty', ->
      it 'does nothing if array has values', ->
        Contract.notEmpty [1,2], 'blahlbah'
        Contract.notEmpty [1], 'blahblah'
      it 'throw error if array is empty', ->
        expect(-> Contract.notEmpty [], 'oh no!').toThrow(new Error('oh no!'))
