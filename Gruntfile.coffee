module.exports = (grunt) ->

  grunt.initConfig

    pkg: grunt.file.readJSON('package.json')

    meta:
      version: '<%= pkg.version %>'
      banner: [
        '# Brace JS (A backbone framework)',
        '#',
        '# V<%= pkg.version %>',
        '#',
        '# Copyright (c)<%= grunt.template.today("yyyy") %> Craig MacGregor',
        '# Distributed under MIT license',
        '#',
        '# https://github.com/craigerm/bracejs',
        ''
        ].join('\n')

    preprocess:
      core:
        files:
          'tmp/brace-core.coffee': 'src/build/core.coffee'
      
    concat:
      options:
        banner: '<%= meta.banner %>'
      build:
        src: ['tmp/brace-core.coffee']
        dest: 'lib/brace.coffee'

    coffee:
      sources:
        files:
          'tmp/src/brace.js': 'lib/brace.coffee'
      specs:
        expand: true
        src: 'spec/*.coffee'
        dest: 'tmp/spec/'
        flatten: true
        ext: '.js'

    watch:
      specs:
        files: ['spec/*.coffee']
        tasks: ['coffee:specs']
      sources:
        files: ['src/*.coffee']
        tasks: ['coffee:sources']
      jsfiles:
        files: ['tmp/**/*.js']
        tasks: ['jasmine:sources']

    jasmine:
      sources:
        src: ['src/brace.js']
      options:
        helpers: 'spec/helpers/**/*.js'
        keepRunner: true
        specs: 'tmp/spec/**/*.js'
        template: require('grunt-template-jasmine-requirejs')
        templateOptions:
          requireConfig:
            baseUrl: 'tmp'
            paths:
              jquery: '../vendor/javascripts/jquery'
              underscore: '../vendor/javascripts/underscore'
              backbone: '../vendor/javascripts/backbone'
              brace: 'src/brace'
            shim:
              jquery:
                exports: '$'
                init: () ->
                  @$.noConflict()
              underscore:
                exports: '_'
                init: () ->
                  @_.noConflict()
              backbone:
                exports: 'Backbone'
                deps: ['underscore', 'jquery']
                init: () ->
                  @Backbone.noConflict()

    connect:
      server:
        options:
          port: 8000

  grunt.loadNpmTasks 'grunt-preprocess'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-notify'

  grunt.registerTask 'build', ['preprocess', 'concat']
  grunt.registerTask 'test', ['build','coffee', 'jasmine:sources']
  grunt.registerTask 'default', ['preprocess', 'concat']

