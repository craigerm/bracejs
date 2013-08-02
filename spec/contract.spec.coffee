define ['brace'], (Brace) ->

  Contract = Brace.Contract

  describe 'Contract', ->

    describe 'generic error', ->
      it 'has ContractError name', ->
        error = null
        try
          Contract.present(null, 'test')
        catch e
          error = e

        expect(e).not.toBeNull()
        expect(e.name).toBe('ContractError')

    describe '#notEmpty', ->

      it 'does nothing if array has values', ->
        Contract.notEmpty [1,2], 'blahlbah'
        Contract.notEmpty [1], 'blahblah'

      it 'throws error if array is empty', ->
        expect(-> Contract.notEmpty [], 'oh no!').toThrow(new Error('oh no!'))

    describe '#present', ->

      it 'does nothing if has a value', ->
        Contract.present {}
        Contract.present []
        Contract.present 500

      it 'throws error if object is null', ->
        expect(-> Contract.present(null,'my error')).toThrow(new Error('my error'))

      it 'throws error if object is undefined', ->
        expect(-> Contract.present(undefined, 'zap')).toThrow(new Error('zap'))

    describe '#fail', ->
      it 'always throws exception', ->
        block = -> Contract.fail 'oh no!'
        expect(block).toThrow(new Error('oh no!'))

