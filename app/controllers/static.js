"use strict";

/**
 * @file
 * Handles static site requests.
 */

var mainNavigation = require('../lib/mainNavigation');
var scriptHandler = require('../lib/scriptHandler');

/**
 * Handles index request.
 */
exports.index = function (req, res) {
  var params = {
    title: '',
    menu: mainNavigation.getItems('home'),
    js_files: scriptHandler.getFiles('/')
  };
  res.render('index', params);
};
