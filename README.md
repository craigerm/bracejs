# Code name: BraceJS
An opinionated mini-framework on top of backbone written in coffeescript.

[![Build Status](https://travis-ci.org/craigerm/bracejs.png?branch=master)](https://travis-ci.org/craigerm/bracejs)

## Status
This is a work in progress and is not quite ready for the real world.

## Goals
- Controllers that can load data or make other async calls and render view when
  ready.
- Action filters in controllers that can peform async work and either stop the
  rendering pipeline, redirect, or continue. Like rails filters
- Rails like routing that will auto-require controllers via requireJS
- Provide base classes for common cases to reduce as much boiler plate code
- Add layouts that are only re-rendered when needed. Controller will set which
  layout it needs and braceJS will determine if it is currently active or if it
  needs to be re-rendered. View will have access to parent layout
- Allow flash support for showing messages
- Ability to organize areas of application into subfolders and load areas on
  demand.

## Extra 
Not sure if this will be in core, or available as a plugin.
- Provide widgets (via bootstrap) for flashes, confirm, and others (maybe
  grid?)

## This will depend on
- backbone (obvs!)
- requirejs
- bootstrap
- handlebars

## Inspired by the following super awesome frameworks (and countless others)
MarionetteJS, Chaplin, Rendr, Sinatra, Rails

## License
Copyright (c) Craig MacGregor 2013 under [MIT LICENSE](/MIT-LICENSE)
