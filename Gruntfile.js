module.exports = function (grunt) {
  "use strict";
  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    concurrent: {
      dev: {
        tasks: ['nodemon', 'watch'],
        options: {
          logConcurrentOutput: true
        }
      }
    },
    nodemon: {
      dev: {
        script: 'server.js',
        options: {
          watch: ['./', './app/views'],
          callback: function (nodemon) {
            nodemon.on('log', function (event) {
              console.log(event.colour);
            });
            // refreshes browser when server reboots
            nodemon.on('restart', function () {
              // Delay before server listens on port
              setTimeout(function() {
                require('fs').writeFileSync('.grunt/rebooted', 'rebooted');
              }, 1000);
            });
          }
        }
      }
    },
    watch: {
      server: {
        files: [
          '.grunt/rebooted',
          'app/views/*',
          'app/views/parts/*',
          'app/views/parts/player/*',
          'app/views/parts/bootstrap/*',
          'public/*',
          'public/css/*',
          'public/css/parts/*'
        ],
        options: {
          livereload: true
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-nodemon');
  grunt.loadNpmTasks('grunt-concurrent');
};
