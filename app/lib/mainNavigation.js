"use strict";

/**
 * @file
 * Handles the main navigation.
 */

/**
 * Define the main menu structure.
 * @type {{home: {label: string, url: string}}}
 */
var items = {
  'home': {
    label: 'Home',
    url: '/'
  }
};

function getItems(current_item) {
  var menu = {
    items: items,
    active: current_item
  };
  return menu;
}

exports.getItems = getItems;
