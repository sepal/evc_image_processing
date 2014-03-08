"use strict";

/**
 * @file
 * Handles routing.
 */


var staticSiteController = require("./controllers/static");


/**
 * Expose routes.
 */
module.exports = function (app) {
// Routes to static pages.
  app.get('/', staticSiteController.index);

}
