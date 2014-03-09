
# Convert all checkboxes to bootstrap switches
$('input[type="checkbox"],[type="radio"]').not('#create-switch').bootstrapSwitch();

# Convert the radius input text to a bootstrap slider.
$('.blur-radius').slider();

$('.tilt-shift-button').click ->
  img = $('.image').get(0);
  radius = $('.blur-radius').slider('getValue')

  Caman img, ->
    @myBlur(radius)
    @render()
    return
  return

$('.revert-button').click ->
  img = $('.image').get(0);
  Caman img, ->
    @revert true
    return
  return
