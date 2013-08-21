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

    color_to_differ_from = @colors.background

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
    counts = {}
    p      = pixels

    for i in [0...pixels.length] by 4
      rgb = [p[i], p[i+1], p[i+2]]
      continue if @colors.background and not @contrasts_background(rgb)

      key = rgb.join(',')

      counts[key] or= 0
      counts[key]  += 1

    colors = Object.keys(counts).sort (a, b) ->
      counts[b] - counts[a]

    i = 0
    while colors[i]
      j = i + 1
      while colors[j]
        if @are_differing(colors[i], colors[j])
          j++
        else
          counts[colors[i]] += counts[colors[j]]
          colors.splice(j, 1)
      i++
    colors.sort (a, b) ->
      counts[b] - counts[a]

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

  are_differing: (a, b, diff = 3000) ->
    @distance_squared(a, b) > diff

  is_dark: (color) ->
    @ybr(color)[0] < 127

  are_contrasting: (a, b, diff = 50) ->
    Math.abs(@ybr(a)[0] - @ybr(b)[0]) > diff

  contrasts_background: (color_key) ->
    @are_contrasting(@colors.background, color_key)

ColorFinder.analyze = (image_url, callback) ->
  new ColorFinder(image_url).analyze(callback)
