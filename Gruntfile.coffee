module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    watch:
      coffee:
        files: ['coffee/**/*.coffee']
        tasks: ['newer:coffee']
      scss:
        files: ['scss/**/*.scss']
        tasks: ['sass']

      livereload:
        options:
          livereload: true
        files: [
          'public/js/**/*.js'
          'public/css/**/*.css'
        ]


    coffee:
      options:
        bare: true
      src:
        expand: true
        cwd: 'coffee'
        src: ['**/*.coffee']
        dest: 'public/js/'
        ext: '.js'

    sass:
      options:
        style: 'expanded'
      src:
        src: 'scss/website.scss'
        dest: 'public/css/website.css'

    bower:
      install:
        options:
          install: true
          copy: false
          cleanTargetDir: false
          cleanBowerDir: false

    copy:
      css:
        src: 'bower_components/normalize.css/normalize.css'
        dest: 'scss/normalize.scss'
      js:
        expand: true
        flatten: true
        cwd: 'bower_components'
        src: [
          'jquery/dist/jquery.js'
          'lodash/dist/lodash.js'
          'requirejs/require.js'
        ]
        dest: 'public/js/vendor/'

    clean:
      public:
        src: [
          'public/css/**/*'
          'public/js/**/*'
        ]

  require('load-grunt-tasks') grunt

  grunt.registerTask 'start_web_server', ->
    grunt.log.writeln('Started web server on port 3000');
    require('./server').listen(3000)

  grunt.registerTask 'bower_install', [
    'bower:install'
    'copy:css'
    'copy:js'
  ]

  grunt.registerTask 'build', [
    'bower_install'
    'coffee'
    'sass'
  ]

  #DEFAULT TASKS
  grunt.registerTask 'default', [
    'start_web_server'
    'watch'
  ]