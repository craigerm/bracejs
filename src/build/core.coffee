define [
  'underscore',
  'backbone',
  'jquery'
], (_, Backbone, $) ->

  noop = ->

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

  # Expose the objects
  Brace =
    Application: Application
    Controller: Controller
    Util: Util
    View: View
    Model: Model
    Layout: Layout
    Router: Router
