class window.PolygonBreeder
  height: 500
  width:  500
  polygon_count: 100
  polygon_points: 3

  constructor: (@image_url) ->
    @polygons          = []
    @canvas            = document.createElement('canvas')
    @canvas.width      = @width
    @canvas.height     = @height
    @ctx               = @canvas.getContext('2d')
    @image             = new Image
    @image.crossOrigin = "anonymous"

    @after_image_loads =>
      @ctx.drawImage(@image, 0, 0, @width, @height)
      @pixels = @image_data()

  after_image_loads: (fn) ->
    @image.onload = =>
      fn?(this)
    @image.src = @image_url
    this

  similarity: ->
    image_data = @image_data()
    total = 0
    for p, i in @pixels
      total += p * image_data[i]

    total / Math.pow(@width * @height * 4, 2)

  image_data: (left = 0, top = 0, width = @width, height = @height) ->
    @ctx.getImageData(left, top, width, height).data

  draw_polygon: (polygon) ->
    c = polygon.color

    @ctx.fillStyle = "hsla(#{c[0]}, #{c[1]}%, #{c[2]}%, #{c[3]})"
    @ctx.beginPath()
    @ctx.moveTo(polygon.points[0][0] * @width, polygon.points[0][1] * @height)

    for i in [1...polygon.points.length]
      point = polygon.points[i]
      @ctx.lineTo(point[0] * @width, point[1] * @height)

    @ctx.closePath()
    @ctx.fill()
    this

  draw: ->
    @ctx.clearRect 0, 0, @width, @height
    for polygon in @polygons
      @draw_polygon(polygon)
    this

  random_polygon: ->
    points: ([@rand(), @rand()] for i in [0...@polygon_points])
    color: [@rand(360), @rand(100), @rand(100), @rand()]

  rand: (max = 1) -> Math.random() * max

  random_polygons: ->
    for i in [0...@polygon_count]
      @random_polygon()
