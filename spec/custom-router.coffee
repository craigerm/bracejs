define ['brace', 'backbone'], (Brace, Backbone) ->

  describe 'CustomRouter', ->

    beforeEach ->
      Backbone.history.stop()

    routes = (match) ->
      match 'users/:id', 'users#show'
      match 'users', 'users#index'

    describe 'test', ->
      it 'triggers router change', ->
        router = new Brace.Router(routes, pushState: false)
        router.start()
        router.customRouter.on 'route-changed', (info) ->
          console.log 'INFO %', info
        router.on 'route-changed', (info) ->
          console.log 'MAIN ROUTER ROUTE CHANGE'

        router.customRouter.navigate 'users', trigger: true
