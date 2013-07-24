define ['brace', 'backbone', 'underscore'], (Brace, Backbone, _) ->

  describe 'dependencies', ->

    it 'has jQuery like lib defined', ->
      expect($).toBeDefined()
      expect(Brace.$).toBeDefined()

  describe 'namespace', ->

    it 'has Application', ->
      expect(_.isObject(Brace.Application)).toBeTruthy()

    it 'has Controller', ->
      expect(_.isObject(Brace.Controller)).toBeTruthy()

    it 'has Util', ->
      expect(_.isObject(Brace.Util)).toBeTruthy()
    
    it 'has View', ->
      expect(_.isObject(Brace.View)).toBeTruthy()

    it 'has Model', ->
      expect(_.isObject(Brace.Model)).toBeTruthy()

    it 'has Layout', ->
      expect(_.isObject(Brace.Layout)).toBeTruthy()

    it 'has LayoutManager', ->
      expect(_.isObject(Brace.LayoutManager)).toBeTruthy()

    it 'has Router', ->
      expect(_.isObject(Brace.Router)).toBeTruthy()

    it 'has CustomRouter', ->
      expect(_.isObject(Brace.CustomRouter)).toBeTruthy()

