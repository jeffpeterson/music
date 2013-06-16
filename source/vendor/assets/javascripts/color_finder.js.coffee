Array.prototype.inject = (init, fn) -> @reduce(fn, init)

class window.ColorFinder
  constructor: (@image_url, callback) ->
    @colors =
      background: "0,0,0"
      primary:    "255,255,255"
      secondary:  "255,255,255"
      detail:     "255,255,255"
    @canvas            = document.createElement 'canvas'
    @image             = new Image
    @ctx               = @canvas.getContext('2d')
    @image.crossOrigin = "anonymous"
    @image.src         = @image_url
    @image.onload      = =>
      @ctx.drawImage(@image, 0, 0)
      @width  = @canvas.width
      @height = @canvas.height
      @set_background_color()
      @set_text_colors()

      App.memo(@image_url, "colors", @colors)
      callback(@colors)

  beauty_of: (color) ->
    [r, g, b] = (parseInt(c) for c in color.split(','))

    Math.abs(r - g) +
    Math.abs(b - r) +
    Math.abs(g - b)

  image_data: (left = 0, top = 0, width = @width, height = @height) ->
    @ctx.getImageData(left, top, width, height).data

  set_background_color: (edge = "top", size = 2) ->
    color_counts = {}
    edge_pixels  = switch edge
      when "top"    then @image_data(0, 0, @width, size)
      when "right"  then @image_data(@width - size, 0, size, @height)
      when "bottom" then @image_data(0, @height - size, @width, size)
      when "left"   then @image_data(0, 0, size, @height)

    for i in [0...edge_pixels.length] by 4
      rgb = [edge_pixels[i], edge_pixels[i+1], edge_pixels[i+2]].join(',')
      color_counts[rgb] ||= 0
      color_counts[rgb]  += 1

    max_count = 0
    for color, count of color_counts when count > max_count
      @colors.background = color
      max_count          = count

  set_text_colors: (callback) ->
    pixels = @image_data()

    color_counts = {}
    for i in [0...pixels.length] by 4
      rgb = [pixels[i], pixels[i+1], pixels[i+2]].join(',')
      color_counts[rgb] ||= 0
      color_counts[rgb] += 1

    possible_colors = for color, count of color_counts when @contrasts_background(color)
      [color, count]

    console.log possible_colors.length

    if possible_colors.length is 0
      unless @is_dark @colors.background
        @colors.primary = @colors.secondary = @colors.detail = "0,0,0"
      return

    possible_colors   = _(possible_colors).sortBy (color) => @beauty_of(color[0])
    @colors.primary = possible_colors.pop()[0]

    if possible_colors.length is 0
      unless @is_dark @colors.background
        @colors.secondary = @colors.detail = "0,0,0"
      return

    
    possible_colors   = _(possible_colors).sortBy (color) => @contrast(@colors.primary, color[0]) * @beauty_of(color[0])
    @colors.secondary = possible_colors.pop()[0]

    # possible_colors   = _(possible_colors).sortBy (color) => -(@contrast(@colors.primary, color[0]) + @contrast(@colors.secondary, color[0]))
    # @colors.detail = possible_colors.shift()?[0]

  luminosity_of: (color) ->
    [r, g, b] = (Math.pow(p / 255, 2.2) for p in color.split(','))
    (0.2126 * r) + (0.7152 * g) + (0.0722 * b)

  # 4.0 is recommended
  are_contrasting: (a, b) ->
    @contrast(a, b) > 1.8

  contrast: (a, b) ->
    high = @luminosity_of(a) + 0.05
    low  = @luminosity_of(b) + 0.05
    [high, low] = [low, high] if high < low
    high / low

  contrasts_background: (color) ->
    @are_contrasting color, @colors.background

  is_dark: (color) ->
    @luminosity_of(color) < 0.5

ColorFinder.analyze = (image_url, callback) ->
  if colors = App.memo(image_url, "colors")
    return callback(colors)
  else
    new ColorFinder image_url, callback
