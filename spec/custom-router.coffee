define ['brace'], (Brace) ->

  describe 'CustomRouter', ->

    it 'triggers router change', ->
      customRouter = new Brace.CustomRouter(brace_router: new Brace.Router())

