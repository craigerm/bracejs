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
      options:
        bare: true
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
        files: ['spec/js/*.js', 'lib/brace.coffee']
        tasks: ['jasmine:specs']

    jasmine:
      options:
        keepRunner: true
        specs: 'tmp/spec/*.js'
        vendor: [
          'vendor/javascripts/jquery.js',
          'vendor/javascripts/underscore.js',
          'vendor/javascripts/backbone.js'
        ]
      sources:
        src: ['tmp/src/brace.js']

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

  grunt.registerTask 'build', ['preprocess', 'concat']
  grunt.registerTask 'test', ['build','coffee', 'jasmine:sources']
  grunt.registerTask 'default', ['preprocess', 'concat']

