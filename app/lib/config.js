"use strict";

/**
 * @file
 * Config file handling for the server part.
 */

var yaml = require('js-yaml');
var fs = require('fs');
var tools = require('./tools');

var defaultConfig = {
  server : {
    port: 80
  },
  database : {
    path : 'localhost'
  }
};

function load(file) {
  var newConfig, config;

  config = defaultConfig;
  newConfig = yaml.safeLoad(fs.readFileSync(file, 'utf8'));
  tools.extend(config.server, newConfig.server);
  tools.extend(config.database, newConfig.database);

  return config;
}

exports.load = load;
