define ['brace'], (Brace) ->

  describe 'Layout', ->

    class FlashView extends Brace.View
      template: Handlebars.compile('<div class="alert alert-{{type}}">{{message}}</div>')

    class MyLayout extends Brace.Layout
      template: Handlebars.compile('<div data-region="flash" id="flash"></div><div id="content"></div>')
      container: 'body'
      flashView: FlashView
      regions:
        content: '#content'
        flash: '#flash'

    layout = null

    describe '#setFlash', ->

      beforeEach ->
        layout = new MyLayout(navigator: {})
        $('body').append(layout.render().el)

      afterEach ->
        layout.remove()

      it 'sets the message on the view', ->
        layout.setFlash('test123')
        expect(layout.$el.find('#flash').text()).toBe('test123')

      it 'sets type to info if not specified', ->
        layout.setFlash('hello world')
        expect(layout.$el.find('div.alert.alert-info').length).toBe(1)

      it 'uses type passed as an option', ->
        layout.setFlash('test', type: 'success')
        expect(layout.$el.find('div.alert.alert-success').length).toBe(1)


