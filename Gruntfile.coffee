###
	hash-tabs

	Gruntfile.coffee

	@author Sean
	
	@note Created on 2014-06-07 by PhpStorm
	@note uses Codoc
	@see https://github.com/coffeedoc/codo
###

"use strict"
module.exports = (grunt) ->

	# Load all grunt tasks
	require("load-grunt-tasks") grunt

	# Show elapsed time at the end
	require("time-grunt") grunt

	# Project configuration.
	grunt.initConfig

	# Metadata.
		pkg: grunt.file.readJSON("package.json")
		banner: "/*! <%= pkg.name %> - v<%= pkg.version %> - " + "<%= grunt.template.today(\"yyyy-mm-dd\") %>\n" + "<%= pkg.homepage ? \"* \" + pkg.homepage + \"\\n\" : \"\" %>" + "* Copyright (c) <%= grunt.template.today(\"yyyy\") %> <%= pkg.author.name %>;" + " Licensed MIT */\n"

	# Task configuration.
		clean:
			files: ["dist"]

		concat:
			options:
				banner: "<%= banner %>"
				stripBanners: true

			dist:
				src: ["src/jquery.<%= pkg.name %>.js"]
				dest: "dist/jquery.<%= pkg.name %>.js"

		uglify:
			options:
				banner: "<%= banner %>"

			dist:
				src: "<%= concat.dist.dest %>"
				dest: "dist/jquery.<%= pkg.name %>.min.js"

		qunit:
			all:
				options:
					urls: ["http://localhost:9000/test/<%= pkg.name %>.html"]

		jshint:
			options:
				reporter: require("jshint-stylish")

			gruntfile:
				options:
					jshintrc: ".jshintrc"

				src: "Gruntfile.js"

			src:
				options:
					jshintrc: "src/.jshintrc"

				src: ["src/**/*.js"]

			test:
				options:
					jshintrc: "test/.jshintrc"

				src: ["test/**/*.js"]

		watch:
			gruntfile:
				files: "<%= jshint.gruntfile.src %>"
				tasks: ["jshint:gruntfile"]

			src:
				files: "<%= jshint.src.src %>"
				tasks: [
					"jshint:src"
					"qunit"
				]

			test:
				files: "<%= jshint.test.src %>"
				tasks: [
					"jshint:test"
					"qunit"
				]

		connect:
			server:
				options:
					hostname: "*"
					port: 9000


	# Default task.
	grunt.registerTask "default", [
		"jshint"
		"connect"
		"qunit"
		"clean"
		"concat"
		"uglify"
	]
	grunt.registerTask "server", ->
		grunt.log.warn "The `server` task has been deprecated. Use `grunt serve` to start a server."
		grunt.task.run ["serve"]
		return

	grunt.registerTask "serve", [
		"connect"
		"watch"
	]
	grunt.registerTask "test", [
		"jshint"
		"connect"
		"qunit"
	]