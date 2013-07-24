define [
  'underscore',
  'backbone',
  'jquery'
], (_, Backbone, $) ->

  noop = ->

  Brace = {}

# @include ../util.coffee
# @include ../event-hooks.coffee
# @include ../model.coffee
# @include ../navigator.coffee
# @include ../custom-router.coffee
# @include ../controller.coffee
# @include ../router.coffee
# @include ../view.coffee
# @include ../layout-manager.coffee
# @include ../layout.coffee
# @include ../dispatcher.coffee
# @include ../application.coffee

  # Expose the objects. Will refactor this later
  Brace.Application = Application
  Brace.Controller = Controller
  Brace.Util = Util
  Brace.View = View
  Brace.Model = Model
  Brace.Layout = Layout
  Brace.LayoutManager = LayoutManager
  Brace.Router = Router
  Brace.CustomRouter = CustomRouter

  Brace
