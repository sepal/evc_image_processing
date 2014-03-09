"use strict";

/**
 * @file
 * Handles all client js files.
 */

var tools = require("./tools");

/**
 * An array of objects, which contain the url js files which should be included.
 * The first field called url specifies the location to the file. The second
 * field location is optional and specifies whether the file should be included
 * in the header or the footer(=default).
 * @type {Array}
 */
var default_js_files = [
  {'url' : "/lib/jquery/dist/jquery.min.js", 'location' : 'header'},
  {'url' : "/lib/bootstrap/dist/js/bootstrap.min.js"},
  {'url' : "/lib/bootstrap-switch/build/js/bootstrap-switch.js"},
  {'url' : "/lib/seiyria-bootstrap-slider/dist/bootstrap-slider.min.js"},
  {'url' : "/lib/angular/angular.js", 'location' : 'header'},
  {'url' : "/lib/angular-route/angular-route.js", 'location' : 'header'},
  {'url' : "/lib/angular-resource/angular-resource.js", 'location' : 'header'},
  {'url' : "/lib/caman/dist/caman.full.js", 'location' : 'header'},
  {'url' : "/js/core.js", 'location' : 'header'},
  {'url' : "/js/app.js", 'location' : 'header'},
  {'url' : "/js/controllers.js", 'location' : 'header'},
  {'url' : "/js/services.js", 'location' : 'header'},
  {'url' : "/js/filters.js", 'location' : 'header'},
  {'url' : "/js/imageProcessor.js", 'location' : 'footer'}
];

/**
 * This defines object with array fields containing paths js which should be
 * included for a specific route. Defining a js file works similar to
 * @see default_js_files.
 * @type {{path: Array}}
 */
var site_files = {
};

function getFiles(route) {
  var files = default_js_files;

  if (site_files[route]) {
    files = files.concat(site_files[route]);
  }
  if (process.env.NODE_ENV === 'development') {
    files = files.concat({
      'url' : "http://localhost:35729/livereload.js",
      'location' : 'header'
    });
  }
  return files;
}

exports.getFiles = getFiles;
