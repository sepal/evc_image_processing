"use strict";
/**
 * @file
 * Provides additional utility functions.
 */


/**
 * Shows a message at the top of the content region.
 *
 * @param text The text of the message.
 * @param type Either info, success, warning, or error. Default is info.
 */
function showMessage(text, type) {
  var $message, $button, icon, state_class;

  type = (type || "info");

  switch (type) {
  case 'info':
    icon = "fa-info";
      state_class = "alert-info";
    break;
  case 'success':
    icon = "fa-check";
    state_class = "alert-success";
    break;
  case 'warning':
    icon = "fa-exclamation";
    state_class = "alert-warning";
    break;
  case 'error':
    icon = "fa-times";
    state_class = "alert-danger";
    break;

  }
  $button = $('<button class="close div fa fa-times-circle" type="button" data-dismiss="alert" aria-hidden="true"></button>');

  $message = $('<div class="alert fade in fa"></div>')
    .addClass(state_class)
    .addClass(icon)
    .text(text)
    .append($button);

  $('.alert-container').append($message);

}
