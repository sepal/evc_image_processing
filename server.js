"use strict";

/**
 * Main file
 */

// Module dependencies
var express = require("express"),
  path = require('path'),
  fs = require('fs'),
  mongoose = require('mongoose'),
  config = require("./app/lib/config");


var serverConf = config.load("./config/config.yml");

var app = module.exports = express();

// Connect to mongodb.

var authentication = "";

if (serverConf.database.user && serverConf.database.password) {
  authentication = serverConf.database.user + ':' + serverConf.database.password + '@';
}

var db_path = 'mongodb://' + authentication + serverConf.database.path;
console.log("Connecting to mongo db server: %s", db_path);
mongoose.connect(db_path);

// Check node_env, if not set default to development
process.env.NODE_ENV = (process.env.NODE_ENV || serverConf.server.env || "development");

// Configuration, defaults to jade as the view engine
app.configure(function () {
  app.set('views', path.join(__dirname, 'app/views'));
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(require('less-middleware')(path.join(__dirname, 'public')));
  app.use(express.static(path.join(__dirname, '/public')));
});

// Bootstrap models
var models_path = path.join(__dirname, '/app/models');
fs.readdirSync(models_path).forEach(function (file) {
  if (~file.indexOf('.js')) require(models_path + '/' + file)
});

require('./app/routes')(app);

app.listen(serverConf.server.port, function () {
  console.log("Express server listening on port %d in %s mode", serverConf.server.port, app.settings.env);
});
