# Linear interpolation between two points.
lerp = (v0, v1, t) ->
  v0 + (v1-v0) * t

# Register a new blur plugin
Caman.Plugin.register "myBlur", (radius, gradient_center, gradient_width) ->
  # only do something if the radius >= 1
  return if isNaN(radius) || radius < 1
  radius |= 1

  gradient_width |= 100;

  # Get the pixels and the dimensions of the image.
  pixels = @pixelData
  width = @dimensions.width
  height = @dimensions.height


  gradient_center |= (height / 2) + 30
  gradient_half_width = gradient_width / 2

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
          # Currently ignore the edges.
          y_div = y_k - radius
          x_div = x_k - radius
          j = (y - y_div) * width * 4 + (x - x_div) * 4

          # Add the multiplication of the neighbours pixel value with the value
          # of the kernel and add it as result.
          new_value[0] += pixels[j] * blur_kernel[y_k][x_k]
          new_value[1] += pixels[j + 1] * blur_kernel[y_k][x_k]
          new_value[2] += pixels[j + 2] * blur_kernel[y_k][x_k]


      new_value[0] /= divisor
      new_value[1] /= divisor
      new_value[2] /= divisor

      # Calculate the upper half gradient
      if (y > gradient_center - gradient_half_width && y <= gradient_center)
        t = ((y+gradient_half_width)-gradient_center) / gradient_half_width
        new_value[0] = lerp(new_value[0], pixels[i], t);
        new_value[1] = lerp(new_value[1], pixels[i + 1], t);
        new_value[2] = lerp(new_value[2], pixels[i + 2], t);

      # Calculate the lower half gradient
      if (y >= gradient_center && y < gradient_center + gradient_half_width)
        t = (y-gradient_center + 1) / gradient_half_width

        new_value[0] = lerp(pixels[i], new_value[0], t);
        new_value[1] = lerp(pixels[i + 1], new_value[1], t);
        new_value[2] = lerp(pixels[i + 2], new_value[2], t);



      pixels[i] = new_value[0]
      pixels[i + 1] = new_value[1]
      pixels[i + 2] = new_value[2]


  @

Caman.Filter.register "myBlur", (radius) ->
  @processPlugin "myBlur", [radius]