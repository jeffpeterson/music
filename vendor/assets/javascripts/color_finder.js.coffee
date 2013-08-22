class window.ColorFinder
  ybr_memo: {}
  width:  100
  height: 100
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

    colors = @find_colors(@image_data(), subsample: 2)

    @colors.primary   = colors.shift() or @colors.contrast
    @colors.secondary = colors.shift() or @colors.primary
    @colors.detail    = colors.shift() or @colors.secondary

  image_data: (left = 0, top = 0, width = @width, height = @height) ->
    @ctx.getImageData(left, top, width, height).data

  find_background: (size = 1, offset = 0) ->
    edge_pixels  = []
    edge_pixels.push @image_data(offset, offset, @width - offset * 2, size)...
    edge_pixels.push @image_data(@width - offset - size, offset + size, size, @height - offset * 2 - size)...
    colors = @find_colors(edge_pixels, number: 1)
    colors[0]

  find_colors: (pixels, options = {}) ->
    number_of_colors = options.number         or 3
    diff             = options.start_distance or 0
    step_size        = options.step_by        or 500
    subsample        = options.subsample      or 1

    counts = grouped_counts = @count_colors pixels, subsample

    for i in [0...10]
      break if Object.keys(counts).length <= number_of_colors
      counts = grouped_counts
      grouped_counts = @group_colors_by_count(counts, diff += step_size)

    @colors_sorted_by_count counts

  count_colors: (pixels, subsample = 1) ->
    counts = {}
    for i in [0...pixels.length] by (4 * subsample)
      rgb = [pixels[i], pixels[i+1], pixels[i+2]]
      continue if @colors.background and not @contrasts_background(rgb)

      key = rgb.join(',')

      counts[key] or= 0
      counts[key]  += 1
    counts

  colors_sorted_by_count: (counts) ->
    Object.keys(counts).sort (a, b) ->
      counts[b] - counts[a]

  group_colors_by_count:(counts, diff) ->
    groups = {}
    colors = @colors_sorted_by_count(counts)
    i      = 0
    while bucket = colors[i++]
      groups[bucket] = counts[bucket]
      j = i
      while colors[j]
        if @are_differing(bucket, colors[j], diff)
          j++
        else
          groups[bucket] += counts[colors[j]]
          colors.splice(j, 1)
    groups


  ybr: (rgb) ->
    return @ybr_memo[rgb] or= @ybr(rgb.split ',') if typeof rgb is 'string'
    [r, g, b] = rgb

    y  =       (0.299    * r) + (0.587    * g) + (0.114    * b)
    cb = 128 - (0.168736 * r) - (0.331264 * g) + (0.5      * b)
    cr = 128 + (0.5      * r) - (0.418688 * g) - (0.081312 * b)
    [y, cb, cr]

  slice: (obj, keys) ->
    copy = {}
    for key in keys
      copy[key] = obj[key]
    copy

  distance_squared: (a, b) ->
    a   = @ybr a
    b   = @ybr b
    sum = 0

    for i in [0..2]
      sum += Math.pow(a[i] - b[i], 2)
    sum

  are_similar: (a, b, diff) ->
    not @are_differing(a, b, diff)

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
