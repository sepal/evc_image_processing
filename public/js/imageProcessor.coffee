img_width = $(".image").get(0).naturalWidth
img_height = $(".image").get(0).naturalHeight

canvas_width = $(".image").width()
canvas_height = $(".image").height()

# Convert all checkboxes to bootstrap switches
$('input[type="checkbox"],[type="radio"]').not('#create-switch').bootstrapSwitch();

# Convert the radius input text to a bootstrap slider.
$('.blur-radius').slider();



$('.tilt-shift-button').click ->
  img = $('.image').get(0);
  radius = $('.blur-radius').slider('getValue')
  gradient_center_top = ($(".tilt-center").position().top+25) / canvas_height * img_height
  console.log(gradient_center_top);
  Caman img, ->
    @myBlur(radius, gradient_center_top)
    @render()
    return
  return

$('.revert-button').click ->
  img = $('.image').get(0);
  Caman img, ->
    @revert true
    return
  return


$(".tilt-center").css({left: canvas_width/2 - 25, top: canvas_height/2 - 25})

current_element = undefined;
hammertime = $("body").hammer();

hammertime.on "dragstart", ".tilt-center", (event) ->
  current_element = $(".tilt-center")
  return

hammertime.on "drag", ".tilt-overlay" , (event) ->
  return if current_element == undefined
  center = event.gesture.center

  if (center.pageX > $(".image").offset().left && center.pageY > $(".image").offset().top && center.pageX < $(".image").offset().left + canvas_width && center.pageY < $(".image").offset().top + canvas_height)
    #x_pos = center.pageX - 25 - $(".image").offset().left
    y_pos = center.pageY - 25 - $(".image").offset().top
    #y_pos = center.pagey - 25 - $(".tilt-center").offset().top

    current_element.css({ top: y_pos})
  event.gesture.preventDefault()

hammertime.on "dragend", ".tilt-overlay" , (event) ->
  current_element = undefined;
