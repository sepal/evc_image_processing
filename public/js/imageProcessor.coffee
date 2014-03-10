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
  gradient_distance_upper = ($(".tilt-center").position().top - $(".tilt-gradient-upper").position().top) / canvas_height * img_height
  gradient_height_upper = $(".tilt-gradient-upper").height() / canvas_height * img_height
  gradient_height_lower = $(".tilt-gradient-lower").height() / canvas_height * img_height
  Caman img, ->
    @myTiltShift(radius, gradient_center_top, gradient_height_upper, gradient_height_lower)
    @render()
    return
  return

$('.revert-button').click ->
  img = $('.image').get(0);
  Caman img, ->
    @revert true
    return
  return

$('.save-button').click ->
  img = $('.image').get(0);
  Caman img, ->
    this.save('png');
    return
  return

initial_focus_top = canvas_height/2 - 25

$(".tilt-center").css({left: canvas_width/2 - 25, top: initial_focus_top})
$(".tilt-gradient-upper").css({top: initial_focus_top - 50, height: 50})
$(".tilt-gradient-lower").css({top: initial_focus_top + 50, height: 50})


current_element = undefined;
hammertime = $("body").hammer();

hammertime.on "dragstart", ".tilt-center", (event) ->
  current_element = $(".tilt-center")
  return

$(".tilt-center").on "moved", (event, pageX, pageY) ->
  if (pageX > $(".image").offset().left && pageY > $(".image").offset().top && pageX < $(".image").offset().left + canvas_width && pageY < $(".image").offset().top + canvas_height)
    y_pos = pageY - 25 - $(".image").offset().top
    current_element.css({ top: y_pos})
    $(".tilt-gradient-upper").css({top: y_pos - 50})
    $(".tilt-gradient-lower").css({top: y_pos + 50})
  return

hammertime.on "dragstart", ".tilt-gradient-upper .tilt-gradient-size .handler", (event) ->
  current_element = $(".tilt-gradient-upper .tilt-gradient-size")
  return

$(".tilt-gradient-upper .tilt-gradient-size").on "moved", (event, pageX, pageY) ->
  y1 = pageY - $(".image").offset().top;
  y2 = $(".tilt-gradient-upper").position().top + $(".tilt-gradient-upper").height();
  $(".tilt-gradient-upper").css({top: y1, height: y2 - y1})
  return

hammertime.on "dragstart", ".tilt-gradient-lower .tilt-gradient-size .handler", (event) ->
  current_element = $(".tilt-gradient-lower .tilt-gradient-size")
  return

$(".tilt-gradient-lower .tilt-gradient-size").on "moved", (event, pageX, pageY) ->
  y = pageY - $(".tilt-gradient-lower").offset().top;
  $(".tilt-gradient-lower").css({height: y})
  return


hammertime.on "drag", ".tilt-overlay" , (event) ->
  return if current_element == undefined
  current_element.trigger("moved", [event.gesture.center.pageX, event.gesture.center.pageY])
  event.gesture.preventDefault()

hammertime.on "dragend", ".tilt-overlay" , (event) ->
  current_element = undefined;
  return
