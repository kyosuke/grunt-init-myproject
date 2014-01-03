glob = require('glob')

getDeplyUploadFiles = ->
  glob.sync("dest/**/*").map (path) ->
    src: path
    dest: path.replace("dest/", "")

#global module:false
module.exports = (grunt) ->
  
  # Project configuration.
  grunt.initConfig
    
    # Metadata.
    pkg: grunt.file.readJSON("package.json")
    config: grunt.file.readJSON("config.json")
    
    # Task configuration.
    clean: ["dest"]
    copy:
      main:
        files: [
          expand: true
          cwd: 'src/'
          src: ["favicon.ico", "common/**/*", "img/*", "files/*"]
          dest: "dest/"
        ]
    jade:
      compile:
        files: [
          expand: true
          cwd: 'src/'
          src: ['**/!(_)*.jade']
          dest: 'dest/'
          ext: '.html'
        ]
    connect:
      server:
        options:
          port: process.env["PORT"] or 3000
          base: "dest"
    watch:
      gruntfile:
        files: "src/**/*"
        tasks: ["compile"]
    s3:
      options:
        key: "<%= config.aws.key %>"
        secret: "<%= config.aws.secret %>"
        bucket: "www.example.com"
        access: "public-read"
        endpoint: "s3-ap-northeast-1.amazonaws.com"
      dev:
        upload: getDeplyUploadFiles()
  
  # These plugins provide necessary tasks.
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-s3"
  
  # Compile task.
  grunt.registerTask "compile", ["copy", "jade"]

  # Default task.
  grunt.registerTask "default", ["clean", "compile", "connect", "watch"]

  # Deploy task.
  grunt.registerTask "deploy", ["clean", "compile", "s3"]





