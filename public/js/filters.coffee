# Linear interpolation between two points.
lerp = (v0, v1, t) ->
  v0 + (v1-v0) * t

Gradient = (from, to) ->
  @from = from
  @to = to
  @width = to - from;

  @

# Register a new blur plugin
Caman.Plugin.register "myTiltShift", (radius, focus_center, gradient_height, gradient_distance) ->
  # only do something if the radius >= 1
  return if isNaN(radius) || radius < 1

  # Get the pixels and the dimensions of the image.
  pixels = @pixelData
  width = @dimensions.width
  height = @dimensions.height


  focus_center = focus_center or (height / 2) + 30
  gradient_height = gradient_height | 50
  gradient_distance = gradient_distance or 20

  # Calculate gradient maps
  upper_gradient = new Gradient(focus_center - gradient_height - gradient_distance, focus_center - gradient_distance)
  lower_gradient = new Gradient(focus_center+ gradient_distance, focus_center + gradient_distance + gradient_height )

  # Calculate the array size for the kernel.
  kernel_size = radius * 2 + 1
  # Calculate the kernel divisor
  divisor = (kernel_size * kernel_size);

  # Create a new kernel for the blur.
  blur_kernel = new Array()
  for y in [0...kernel_size]
    blur_kernel[y] = new Array()
    for x in [0...kernel_size]
      blur_kernel[y][x] = 1


  # Manipulate all pixels.
  for y in [0...height]
    for x in [0...width]

      # Cancel pixel manipulation for the region, which should stay unblured.
      break if (y >= upper_gradient.to && y <= lower_gradient.from)

    # Calculate current position in the one dimensional pixel array.
      i = y * width * 4 + x * 4

      # Create a variable for the resulting values.
      new_value = new Array()
      new_value[0] = 0
      new_value[1] = 0
      new_value[2] = 0

      # Calculate the convulution for each pixel value.
      for y_k in [0...kernel_size]
        for x_k in [0...kernel_size]

          # Calculate the position of the neighbour pixel.
          y_div = y_k - radius
          x_div = x_k - radius

          # Handle the edges by selecting the first/last index if out of border.
          y_div = 0 if (y + y_div) < 0 or (y + y_div) >= (height - 1)
          x_div = 0 if (x + x_div) < 0 or (x + x_div) >= (width - 1)

          j = (y + y_div) * width * 4 + (x + x_div) * 4

          # Add the multiplication of the neighbours pixel value with the value
          # of the kernel and add it as result.
          new_value[0] += pixels[j] * blur_kernel[y_k][x_k]
          new_value[1] += pixels[j + 1] * blur_kernel[y_k][x_k]
          new_value[2] += pixels[j + 2] * blur_kernel[y_k][x_k]


      new_value[0] /= divisor
      new_value[1] /= divisor
      new_value[2] /= divisor


      # Calculate the upper half gradient
      if (y > upper_gradient.from && y <= upper_gradient.to)
        t = (y-upper_gradient.from) / upper_gradient.width

        new_value[0] = lerp(new_value[0], pixels[i], t);
        new_value[1] = lerp(new_value[1], pixels[i + 1], t);
        new_value[2] = lerp(new_value[2], pixels[i + 2], t);

      # Calculate the lower half gradient
      if (y > lower_gradient.from && y <= lower_gradient.to)
        t = (y-lower_gradient.from) / lower_gradient.width

        new_value[0] = lerp(pixels[i], new_value[0], t);
        new_value[1] = lerp(pixels[i + 1], new_value[1], t);
        new_value[2] = lerp(pixels[i + 2], new_value[2], t);



      pixels[i] = new_value[0]
      pixels[i + 1] = new_value[1]
      pixels[i + 2] = new_value[2]


  @

Caman.Filter.register "myTiltShift", (radius, focus_center, gradient_height, gradient_distance) ->
  @processPlugin "myTiltShift", [radius, focus_center, gradient_height, gradient_distance]
