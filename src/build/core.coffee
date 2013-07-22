#define [
#  'underscore',
#  'backbone',
#  'jquery'
#], (_, Backbone, $) ->

  noop = ->

# @include ../util.js.coffee
# @include ../event-hooks.js.coffee
# @include ../model.js.coffee
# @include ../navigator.js.coffee
# @include ../custom-router.js.coffee
# @include ../controller.js.coffee
# @include ../router.js.coffee
# @include ../view.js.coffee
# @include ../layout-manager.js.coffee
# @include ../layout.js.coffee
# @include ../dispatcher.js.coffee
# @include ../application.js.coffee

  # Expose the objects
  @Brace =
    Application: Application
    Controller: Controller
    Util: Util
    View: View
    Model: Model
    Layout: Layout
