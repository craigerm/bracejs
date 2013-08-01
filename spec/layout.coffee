define ['brace'], (Brace) ->

  describe 'Layout', ->

    class FlashView extends Brace.View
      template: Handlebars.compile('<div>{{message}}</div>')

    class MyLayout extends Brace.Layout
      template: Handlebars.compile('<div data-region="flash" id="flash"></div><div id="content"></div>')
      container: 'body'
      flashView: FlashView
      regions:
        content: '#content'
        flash: '#flash'

    layout = null

    beforeEach ->
      layout = new MyLayout(navigator: {})
      $('body').append(layout.render().el)

    describe '#setFlash', ->
      it 'sets type to info if not specified', ->
        layout.setFlash('hello world')


