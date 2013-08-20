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
    @image.crossOrigin = "anonymous" unless /^data:/.test(@image_url)

  after_image_loads: (fn) ->
    @image.onload = => fn?(this)
    @image.src = @image_url
    this

  analyze: (callback) ->
    @after_image_loads =>
      @analyze_now()
      callback?(@colors)

  analyze_now: ->
    @ctx.drawImage(@image, 0, 0, @width, @height)

    @colors.background = @find_background()
    @colors.contrast   = if @is_dark(@colors.background) then '255,255,255' else '0,0,0'

    colors = @find_colors(@image_data())
    colors = (color for color in colors when @contrasts_background(color))

    color_to_differ_from = @colors.background
    i = 0
    while colors[i] and colors.length > 3
      if @are_differing(colors[i], color_to_differ_from)
        color_to_differ_from = colors[i++]
      else
        colors.splice(i, 1)

    @colors.primary   = colors.shift() or @colors.contrast
    @colors.secondary = colors.shift() or @colors.primary
    @colors.detail    = colors.shift() or @colors.secondary

  image_data: (left = 0, top = 0, width = @width, height = @height) ->
    @ctx.getImageData(left, top, width, height).data

  find_background: (size = 1, offset = 0) ->
    edge_pixels  = []
    edge_pixels.push @image_data(offset, offset, @width - offset * 2, size)...
    edge_pixels.push @image_data(@width - offset - size, offset + size, size, @height - offset * 2 - size)...
    colors = @find_colors(edge_pixels)
    colors[0]

  find_colors: (pixels) ->
    buckets = (v for k,v of @find_buckets(pixels))
    buckets = _(buckets).sortBy (bucket) -> - bucket.count
    # [{count: 123, colors: {}}, ...]

    buckets.map (bucket) ->
      _(_.pairs(bucket.colors)).max(([rgb, count]) -> count)[0]

  find_buckets: (p) ->
    buckets = {}
    for i in [0...p.length] by 4
      rgbs   = [p[i], p[i+1], p[i+2]]
      rgb    = rgbs.join(',')
      ybr    = @ybr(rgbs)
      step   = @round(ybr).join(',')

      buckets[step]      or= {count: 0, colors: {}}
      buckets[step].count += 1

      buckets[step].colors[rgb] or= 0
      buckets[step].colors[rgb]  += 1

    buckets

  round: (colors) ->
    for color in colors
      Math.round(color / 25) * 25

  ybr: (rgbs) ->
    return @ybr(rgbs.split(',')) if typeof rgbs is 'string'
    [r, g, b] = rgbs

    y  =       (0.299    * r) + (0.587    * g) + (0.114    * b)
    cb = 128 - (0.168736 * r) - (0.331264 * g) + (0.5      * b)
    cr = 128 + (0.5      * r) - (0.418688 * g) - (0.081312 * b)
    [y, cb, cr]

  distance_squared: (a, b) ->
    a   = @ybr a
    b   = @ybr b
    sum = 0

    for i in [0..2]
      sum += Math.pow(a[i] - b[i], 2)
    sum

  are_differing: (a, b, diff = 2000) ->
    @distance_squared(a, b) > diff

  is_dark: (color) ->
    @ybr(color)[0] < 127

  are_contrasting: (a, b, diff = 50) ->
    Math.abs(@ybr(a)[0] - @ybr(b)[0]) > diff

  contrasts_background: (color_key) ->
    @are_contrasting(@colors.background, color_key)

ColorFinder.analyze = (image_url, callback) ->
  new ColorFinder(image_url).analyze(callback)
