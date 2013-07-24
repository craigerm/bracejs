define ['brace', 'underscore'], (Brace, _) ->

  # fake views
  class FakeView extends Brace.View
    template: _.template('<div><span id="name"></div><strong>a</strong><strong>b</strong>')
    ui:
      name: '#name'
      strongs: 'strong'

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

    describe '@ui', ->
      it 'maps ui elements after render', ->
        view = new FakeView()
        view.render()
        expect(view.ui.name.length).toBe(1)
        expect(view.ui.strongs.length).toBe(2)

      it 'remaps ui elements after multiple renders', ->
        view = new FakeView()
        view.render()
        view.render()
        expect(view.ui.name.length).toBe(1)
        expect(view.ui.strongs.length).toBe(2)


