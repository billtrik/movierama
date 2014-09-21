module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    uglify:
      options:
        mangle: false,
        preserveComments: false,
        report: "min",
        compress:
          hoist_funs: false,
          loops: false,
          unused: false
      loader:
        files:
         'public/js/loader.min.js': 'public/js/loader.js'

    concat:
      options:
        separator: '\n'
      loader:
        src: [
          'wrappers/loader_intro.js'
          'compiled/vendor/require.js'
          'compiled/r_config.js'
          'wrappers/loader_outro.js'
        ]
        dest: 'public/js/loader.js'

    requirejs:
      compile:
        options:
          baseUrl: "compiled"
          mainConfigFile: "compiled/r_config.js"
          name: "application"
          out: "public/js/application.js"
          optimize: "uglify2"
          preserveLicenseComments: false

    mocha_casperjs:
      specs:
        options:
          'chai-path':        'node_modules/chai'
          'casper-chai-path': 'node_modules/casper-chai'

        files:
          src: ['spec/**/*_spec.coffee']

    watch:
      wrappers:
        files: ['wrappers/*']
        tasks: [
          'build_loader'
        ]

      static:
        options:
          livereload: true
        files: ['public/index.html']

      coffee:
        files: ['coffee/**/*.coffee']
        tasks: [
          'newer:coffee'
          'requirejs'
          'build_loader'
        ]

      scss:
        files: ['scss/**/*.scss']
        tasks: ['build_scss']

      livereload:
        options:
          livereload: true
        files: [
          'public/js/**/*.js'
          'public/css/**/*.css'
        ]

      spec:
        files: ['spec/**/*_spec.coffee']
        tasks: ['mocha_casperjs']

    coffee:
      options:
        bare: true
      src:
        expand: true
        cwd: 'coffee'
        src: ['**/*.coffee']
        dest: 'compiled/'
        ext: '.js'

    sass:
      expanded:
        options:
          style: 'expanded'
        src: 'scss/website.scss'
        dest: 'public/css/website.css'

      compressed:
        options:
          style: 'compressed'
        src: 'scss/website.scss'
        dest: 'public/css/website.min.css'

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
        dest: 'compiled/vendor/'

    clean:
      public:
        src: [
          'public/css/**/*'
          'public/js/**/*'
          'compiled/**/*'
        ]

  require('load-grunt-tasks') grunt

  grunt.registerTask 'start_web_server', ->
    grunt.log.writeln('Started web server on port 3000');
    require('./server').listen(3000)

  grunt.registerTask 'build_loader', [
    'concat:loader'
    'uglify:loader'
  ]

  grunt.registerTask 'build_scss', [
    'sass'
  ]

  grunt.registerTask 'build_coffee', [
    'coffee'
    'requirejs'
  ]

  grunt.registerTask 'bower_install', [
    'bower:install'
    'copy:css'
    'copy:js'
  ]


  grunt.registerTask 'build', [
    'bower_install'
    'build_scss'
    'build_coffee'
    'build_loader'
  ]

  #DEFAULT TASKS
  grunt.registerTask 'default', [
    'start_web_server'
    'watch'
  ]
  grunt.registerTask 'test', [
    'build'
    'start_web_server'
    'mocha_casperjs'
  ]
