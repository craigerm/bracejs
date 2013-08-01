define ['brace', 'underscore'], (Brace, _) ->

  # fake views
  class FakeView extends Brace.View
    template: _.template('<div><span id="name"></div><input type="text" id="desc" /><strong>a</strong><strong>b</strong>')
    onEnterKey: ->
    ui:
      name: '#name'
      strongs: 'strong'

  describe 'view', ->

    getViewData = (model) ->
      new Brace.View(model: model).getViewData()

    describe '#constructor', ->

      it 'layout is passed via constructor it gets assigned as a property', ->
        view = new Brace.View(layout: {})
        expect(view.options.layout).toBeDefined()
        expect(view.layout).toBeDefined()

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

    describe '@render', ->

      # TODO: Use simulate plugin
      it 'maps onEnterKey handler if it is defined', ->
        spyOn(FakeView.prototype, 'onEnterKey').andCallThrough()
        view = new FakeView()
        view.render()
        event = $.Event('keypress')
        event.which = 13
        view.$el.find('input:first').trigger(event)
        expect(view.onEnterKey).toHaveBeenCalled()

      it 'throws error if no template defined', ->
        view = new FakeView()
        view.template = null
        block = -> view.render()
        expect(block).toThrow(new Error('view:render must have template'))

