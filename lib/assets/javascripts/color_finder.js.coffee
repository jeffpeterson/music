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

      buckets[step]      or= {count: 0, colors: {}}
      buckets[step].count += 1

      buckets[step].colors[rgb] or= 0
      buckets[step].colors[rgb]  += 1

    buckets

  round: (colors) ->
    for color in colors
      Math.round(color / 50) * 50

  yuv: ([r,g,b]) ->
    y = 0.299 * r + (0.587 * g) + (0.114 * b)
    u = 0.492 * (b - y)
    v = 0.877 * (r - y)
    [y, u, v]

  distance_squared: (rgb1, rgb2) ->
    yuv1 = @yuv rgb1
    yuv2 = @yuv rgb2

    _.reduce (Math.pow(p - yuv2[i], 2) for p, i in yuv1), ((sum, i) -> sum + i), 0

  are_contrasting: (a, b) ->
    a = a.split(',')
    b = b.split(',')
    @distance_squared(a, b) > 10000

  contrasts_background: (color) ->
    @are_contrasting color, @colors.background

ColorFinder.analyze = (image_url, callback) ->
  new ColorFinder(image_url).analyze(callback)
