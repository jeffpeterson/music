class window.Chloroform
  ybrMemo: {}
  width:    100
  height:   100

  constructor: (@imageUrl, options = {}) ->
    @colors            = {}
    @canvas            = document.createElement('canvas')
    @canvas.width      = @width
    @canvas.height     = @height
    @ctx               = @canvas.getContext('2d')
    @image             = new Image
    @image.crossOrigin = "anonymous" unless /^data:/.test(@imageUrl)

  afterImageLoads: (fn) ->
    @image.onload = => fn?(this)
    @image.src    = @imageUrl
    this

  analyze: (callback) ->
    @afterImageLoads =>
      @analyzeNow()
      callback?(@colors)

  analyzeNow: ->
    @ctx.drawImage(@image, 0, 0, @width, @height)

    @colors.background = @findBackground()
    @colors.contrast   = if @isDark(@colors.background) then '255,255,255' else '0,0,0'

    colors = @findColors(@imageData(), subsample: 2)

    @colors.primary   = colors.shift() or @colors.contrast
    @colors.secondary = colors.shift() or @colors.primary
    @colors.detail    = colors.shift() or @colors.secondary

  imageData: (left = 0, top = 0, width = @width, height = @height) ->
    @ctx.getImageData(left, top, width, height).data

  findBackground: (size = 1, offset = 0) ->
    edgePixels  = []
    edgePixels.push @imageData(offset, offset, @width - offset * 2, size)...
    edgePixels.push @imageData(@width - offset - size, offset + size, size, @height - offset * 2 - size)...
    @findColors(edgePixels, count: 1)[0]

  findColors: (pixels, options = {}) ->
    numberOfColors = options.count         or 3
    diff           = options.startDistance or 0
    stepSize       = options.stepBy        or 500
    subsample      = options.subsample     or 1

    counts = groupedCounts = @countColors pixels, subsample

    for i in [0...10]
      break if Object.keys(counts).length <= numberOfColors
      counts = groupedCounts
      groupedCounts = @groupColorsByCount(counts, diff += stepSize)

    @colorsSortedByCount counts

  countColors: (pixels, subsample = 1) ->
    counts = {}
    for i in [0...pixels.length] by (4 * subsample)
      rgb = [pixels[i], pixels[i+1], pixels[i+2]]
      continue if @colors.background and not @contrastsBackground(rgb)

      key = rgb.join(',')

      counts[key] or= 0
      counts[key]  += 1
    counts

  colorsSortedByCount: (counts) ->
    Object.keys(counts).sort (a, b) ->
      counts[b] - counts[a]

  groupColorsByCount:(counts, diff) ->
    groups = {}
    colors = @colorsSortedByCount(counts)
    i      = 0
    while bucket = colors[i++]
      groups[bucket] = counts[bucket]
      j = i
      while colors[j]
        if @areDiffering(bucket, colors[j], diff)
          j++
        else
          groups[bucket] += counts[colors[j]]
          colors.splice(j, 1)
    groups


  ybr: (rgb) ->
    return @ybrMemo[rgb] or= @ybr(rgb.split ',') if typeof rgb is 'string'
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

  distanceSquared: (a, b) ->
    a   = @ybr a
    b   = @ybr b
    sum = 0

    for i in [0..2]
      sum += Math.pow(a[i] - b[i], 2)
    sum

  areSimilar: (a, b, diff) ->
    not @areDiffering(a, b, diff)

  areDiffering: (a, b, diff = 3000) ->
    @distanceSquared(a, b) > diff

  isDark: (color) ->
    @ybr(color)[0] < 127

  areContrasting: (a, b, diff = 50) ->
    Math.abs(@ybr(a)[0] - @ybr(b)[0]) > diff

  contrastsBackground: (colorKey) ->
    @areContrasting(@colors.background, colorKey)

Chloroform.analyze = (imageUrl, callback) ->
  new Chloroform(imageUrl).analyze(callback)
