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

      scolors = (color for color in colors when @are_contrasting(color, @colors.primary, 5000))
      @colors.secondary = scolors.shift() or colors.shift() or @colors.primary

      dcolors = (color for color in scolors when @are_contrasting(color, @colors.secondary, 5000))
      @colors.detail    = dcolors.shift() or scolors.shift() or scolors.shift() or @colors.secondary

      callback?(@colors)

  image_data: (left = 0, top = 0, width = @width, height = @height) ->
    @ctx.getImageData(left, top, width, height).data

  find_background: (size = 1, offset = 0) ->
    edge_pixels  = []
    edge_pixels.push @image_data(offset, offset, @width - offset * 2, size)...
    edge_pixels.push @image_data(@width - offset - size, offset + size, size, @height - offset * 2 - size)...
    colors = @find_colors(edge_pixels)
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
      yuv    = @yuv(rgbs)
      step   = @round(yuv[1..2]).join(',')

      buckets[step]      or= {count: 0, colors: {}}
      buckets[step].count += 1

      buckets[step].colors[rgb] or= 0
      buckets[step].colors[rgb]  += 1

    buckets

  round: (colors) ->
    for color in colors
      Math.round(color / 25) * 25

  yuv: ([r,g,b]) ->
    y = 0.299 * r + (0.587 * g) + (0.114 * b)
    u = 0.492 * (b - y)
    v = 0.877 * (r - y)
    [y, u, v]

  distance_squared: (rgb1, rgb2) ->
    yuv1 = @yuv rgb1
    yuv2 = @yuv rgb2

    _.reduce (Math.pow(p - yuv2[i], 2) for p, i in yuv1), ((sum, i) -> sum + i), 0

  are_contrasting: (a, b, diff = 10000) ->
    a = a.split(',')
    b = b.split(',')
    @distance_squared(a, b) > diff

  contrasts_background: (color_key) ->
    Math.abs(@yuv(@colors.background.split(','))[0] - @yuv(color_key.split(','))[0]) > 75

ColorFinder.analyze = (image_url, callback) ->
  new ColorFinder(image_url).analyze(callback)
