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
          'lib/core/brace.js.coffee': 'src/build/core.js.coffee'
      
    concat:
      options:
        banner: '<%= meta.banner %>'
      build:
        src: ['lib/core/brace.js.coffee']
        dest: 'lib/brace.js.coffee'

    jasmine:
      specs: 'spec/**/*.js.coffee'

  grunt.loadNpmTasks 'grunt-preprocess'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'

  grunt.registerTask 'default', ['preprocess', 'concat']

