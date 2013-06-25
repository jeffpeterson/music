class window.ColorFinder
  width:  50
  height: 50
  constructor: (@image_url) ->
    @colors            = {}
    @canvas            = document.createElement('canvas')
    @canvas.width      = @width
    @canvas.height     = @height
    @ctx               = @canvas.getContext('2d')
    @image             = new Image
    @image.crossOrigin = "anonymous"


  after_image_loads: (fn) ->
    @image.onload = =>
      fn?(this)
    @image.src = @image_url
    this

  analyze: (callback) ->
    @after_image_loads =>
      @ctx.drawImage(@image, 0, 0, @width, @height)

      @colors.background = @find_background()

      colors = @find_colors(@image_data())
      colors = (color for color in colors when @contrasts_background(color))

      @colors.primary   = colors.shift()
      @colors.secondary = colors.shift()
      @colors.detail    = colors.shift()

      callback?(@colors)

  image_data: (left = 0, top = 0, width = @width, height = @height) ->
    @ctx.getImageData(left, top, width, height).data

  find_background: (size = 1, offset = 0) ->
    edge_pixels  = @image_data(offset, offset, @width - offset * 2, size)
    colors = @find_colors(edge_pixels)

    if colors.length < 3 and offset < @height / 10
      return @find_background(size, offset + 1)

    colors[0]

  find_colors: (pixels) ->
    buckets = _.values(@find_buckets(pixels))
    buckets = _(buckets).sortBy (bucket) -> - bucket.count
    # [{count: 123, colors: {}}, ...]

    buckets.map (bucket) ->
      _(_.pairs(bucket.colors)).max(([rgb, count]) -> count)[0]

  find_buckets: (p) ->
    buckets = {}
    for i in [0...p.length] by 4
      rgbs   = [p[i], p[i+1], p[i+2]]
      rgb    = rgbs.join(',')
      step   = @round(rgbs).join(',')
      # step   = @round([@hue(rgbs)]).join(',')

      buckets[step]      or= {count: 0, colors: {}}
      buckets[step].count += 1

      buckets[step].colors[rgb] or= 0
      buckets[step].colors[rgb]  += 1

    buckets

  round: (colors) ->
    for color in colors
      Math.round(color / 50) * 50

  hue: ([r, g, b]) ->
    beta  = 0.003396178055 * (g - b)
    alpha = 0.001960784314 * (2 * r - g - b)
    Math.round(Math.atan2(beta, alpha) * 360)

  lightness: (r, g, b) ->
    0.5 * (Math.max(r, g, b) + Math.min(r, g, b))

  luminosity_of: (color) ->
    [r, g, b] = (Math.pow(p / 255, 2.2) for p in color.split(','))
    (0.2126 * r) + (0.7152 * g) + (0.0722 * b)

  are_contrasting: (a, b) ->
    @contrast(a, b) > 2.5
    # 4.0 is recommended by W3C

  contrast: (a, b) ->
    high = @luminosity_of(a) + 0.05
    low  = @luminosity_of(b) + 0.05
    [high, low] = [low, high] if high < low
    high / low

  contrasts_background: (color) ->
    @are_contrasting color, @colors.background

ColorFinder.analyze = (image_url, callback) ->
  new ColorFinder(image_url).analyze(callback)
