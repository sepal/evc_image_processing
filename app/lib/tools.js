"use strict";

/**
 * @file
 * Simple functions that will make life easier.
 */

/**
 * Extends an object with another object
 * @param a Object to be extended.
 * @param b Object which extends.
 */
function extend(a, b) {
  for (var x in b) {
    a[x] = b[x];
  }
}



exports.extend = extend;