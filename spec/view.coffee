define ['brace'], (Brace) ->

  describe 'view', ->

    getViewData = (model) ->
      new Brace.View(model: model).getViewData()

    describe '#getViewData', ->

      it 'returns empty object if no model', ->
        obj = getViewData({})
        expect(_.isEmpty(obj)).toBe(true)

      it 'return model attributes if has attributes', ->
        obj = getViewData(attributes: name: 'John')
        expect(obj.name).toBe('John')

      it 'returns raw model if no attributes', ->
        obj = getViewData(id: 500)
        expect(obj.id).toBe(500)

