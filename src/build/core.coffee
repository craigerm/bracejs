define [
  'underscore',
  'backbone',
], (_, Backbone) ->

  Brace = {}
  noop = ->

  $ = Brace.$ = Backbone.$

# @include ../util.coffee
# @include ../contract.coffee
# @include ../event-hooks.coffee
# @include ../model.coffee
# @include ../navigator.coffee
# @include ../controller.coffee
# @include ../router.coffee
# @include ../view.coffee
# @include ../layout-manager.coffee
# @include ../layout.coffee
# @include ../dispatcher.coffee
# @include ../application.coffee

  # Expose the objects. Will refactor this later
  Brace.Contract = Contract
  Brace.Application = Application
  Brace.Dispatcher = Dispatcher
  Brace.Controller = Controller
  Brace.Util = Util
  Brace.View = View
  Brace.Model = Model
  Brace.Layout = Layout
  Brace.Navigator = Navigator
  Brace.LayoutManager = LayoutManager
  Brace.Router = Router

  Brace
