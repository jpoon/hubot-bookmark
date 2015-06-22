"use strict"

module.exports = (grunt) ->
  grunt.initConfig
    mochaTest:
      test:
        options:
          reporter: "spec"
          require: "coffee-script"

        src: ["test/**/*.coffee"]

    coffeelint:
      app: ["src/*.coffee", "test/*.coffee"]
      options:
        max_line_length:
          level: 'ignore'

    release:
      options:
        tagName: "v<%= version %>"
        commitMessage: "Prepared to release <%= version %>."

    watch:
      files: [
        "Gruntfile.js"
        "test/**/*.coffee"
      ]
      tasks: ['test', 'coffeelint']

  grunt.event.on "watch", (action, filepath, target) ->
    grunt.log.writeln target + ": " + filepath + " has " + action
    return


  # load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks
  grunt.registerTask "test", ['mochaTest']
  grunt.registerTask "default", ['coffeelint', 'test']
  return
