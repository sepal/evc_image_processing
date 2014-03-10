"use strict";

/**
 * @file
 * Handles static site requests.
 */

var path = require('path'),
  fs = require('fs');
var mainNavigation = require('../lib/mainNavigation');
var scriptHandler = require('../lib/scriptHandler');

/**
 * Handles index request.
 */
exports.index = function (req, res) {
  var params = {
    title: 'ImageProcessing',
    menu: mainNavigation.getItems('home'),
    js_files: scriptHandler.getFiles('/')
  };
  res.render('index', params);
};


/**
 * Handles image uploading
 */
exports.upload = function (req, res) {
  fs.readFile(req.files.image.path, function (err, data) {

    var newPath = "public/uploads/" + req.files.image.originalFilename;

    fs.writeFile(newPath, data, function (err) {
      res.redirect('/edit?image=uploads/' + req.files.image.originalFilename);
    });
  });
};

/**
 * Displays the effect editing page.
 */
exports.edit = function (req, res) {
  var img = req.query.image || "uploads/test_img.jpg"
  var params = {
    title: 'ImageProcessing',
    menu: mainNavigation.getItems('home'),
    js_files: scriptHandler.getFiles('/edit'),
    image: img
  };
  res.render('edit', params);
};
