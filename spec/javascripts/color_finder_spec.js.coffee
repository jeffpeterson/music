#= require helpers/color_finder

describe "ColorFinder", ->
  canvas        = document.createElement('canvas')
  canvas.width  = 400
  canvas.height = 400
  ctx           = canvas.getContext('2d')
  url           = -> canvas.toDataURL()

  log_colors = (colors) -> console.image create_swatch(colors)

  create_swatch = (colors) ->
    canvas = document.createElement('canvas')
    canvas.height = 50
    canvas.width  = 170
    ctx           = canvas.getContext('2d')

    ctx.fillStyle = "rgb(#{colors.background})"
    ctx.fillRect(0, 0, canvas.width, canvas.height)

    for key, i in ['primary', 'secondary', 'detail', 'contrast']
      ctx.fillStyle = "rgb(#{colors[key]})"
      ctx.fillRect(10 + i * 40, 10, 30, 30)

    canvas.toDataURL()

  draw = (fg, options) ->
    bg     = options.on
    offset = options.offset or canvas.width * 0.2
    ctx.fillStyle = bg
    ctx.fillRect(0, 0, canvas.width, canvas.height)

    ctx.fillStyle = fg
    ctx.fillRect(offset, offset, canvas.width - offset * 2, canvas.height - offset * 2)

  it "sorts colors by count", ->
    sort = ColorFinder::colors_sorted_by_count
    expect(sort({a:3,c:1,b:2})).to.deep.equal ['a','b','c']

  it "groups colors by count", ->
    group = ColorFinder::group_colors_by_count.bind(new ColorFinder)
    expect(group({'255,255,255':9, '254,254,254':8}, 100)).to.deep.equal {'255,255,255': 17}
    expect(group({'255,255,255':9, '0,0,0':8}, 100)).to.deep.equal {'255,255,255': 9, '0,0,0':8}

  it "counts colors", ->
    count = ColorFinder::count_colors.bind(new ColorFinder)
    expect(count [255,0,0,0, 0,255,0,0, 255,0,0,0]                      ).to.deep.equal {'255,0,0':2, '0,255,0':1}

  it "finds correct list of colors", ->
    expect([255,0,0,0, 0,255,0,0, 255,0,0,0]                      ).to.find_colors '255,0,0', '0,255,0'
    expect([255,0,0,0, 0,255,0,0, 254,0,0,0, 253,0,0,0, 0,255,0,0]).to.find_colors '255,0,0', '0,255,0'

  it "converts to Y'CbCr", ->
    y = ColorFinder::ybr.bind(new ColorFinder)
    expect(y '0,0,0'      ).to.be.about [0  , 128, 128] # black
    expect(y '255,255,255').to.be.about [255, 128, 128] # white
    expect(y '127,127,127').to.be.about [127, 128, 128] # gray
    expect(y '255,0,0'    ).to.be.about [76 , 85 , 255] # red
    expect(y '0,0,255'    ).to.be.about [29 , 255, 107] # blue

  it 'detects darkness', ->
    expect('0,0,0'  ).to.be.dark
    expect('255,0,0').to.be.dark
    expect('0,0,255').to.be.dark

    expect('255,255,255').not.to.be.dark # white
    expect('255,255,0'  ).not.to.be.dark # yellow

  it 'determines contrasting colors', ->
    expect('0,0,0'      ).to.contrast '255,255,255'
    expect('255,255,255').to.contrast '0,0,0'
    expect('0,0,0'      ).to.contrast '255,0,0'
    expect('0,0,0'      ).to.contrast '0,255,0'
    # expect('255,0,0'    ).to.contrast '0,0,255'
    expect('127,127,127').to.contrast '0,0,0'
    expect('127,127,127').to.contrast '255,255,255'
    expect('255,255,255').to.contrast '195,195,195'

    expect('81,174,131' ).not.to.contrast '152,203,178'
    expect('0,0,0'      ).not.to.contrast '0,0,255'
    expect('255,255,255').not.to.contrast '215,215,215'
    expect('0,0,0'      ).not.to.contrast '40,40,40'

  it "finds color in People and Things by Jack's Mannequin", ->
    expect('251,245,228').to.contrast '208,98,40'     # red
    expect('251,245,228').to.contrast '143,205,207'   # blue
    expect('251,245,228').to.contrast '133,170,80'    # green

    expect('208,98,40' ).to.differ_from '143,205,207'
    expect('208,98,40' ).to.differ_from '133,170,80'
    expect('133,170,80').to.differ_from '143,205,207'

  it "finds color in Finale by Madeon", ->
    expect('22,21,27').to.contrast '148,56,119'  # cyan
    expect('22,21,27').to.contrast '118,193,182' # pink
    expect('22,21,27').to.contrast '244,211,1'   # yellow

    expect('148,56,119').to.differ_from '244,211,1'
    expect('148,56,119').to.differ_from '118,193,182'
    expect('244,211,1' ).to.differ_from '118,193,182'

  it "finds color in Live From Shepherd's Bush Empire by Mumford and Sons", ->
    expect('113,78,36').to.contrast '186,146,3'

  it 'determines differing colors', ->
    expect('0,0,0'      ).to.differ_from '255,255,255'
    expect('255,255,255').to.differ_from '0,0,0'
    expect('0,0,0'      ).to.differ_from '255,0,0'
    expect('0,0,0'      ).to.differ_from '0,255,0'
    expect('255,0,0'    ).to.differ_from '0,0,255'
    expect('127,127,127').to.differ_from '0,0,0'
    expect('127,127,127').to.differ_from '255,255,255'
    # expect('255,255,255').to.differ_from '205,205,205'
    expect('0,0,0'      ).to.differ_from '255,255,255'
    expect('0,0,0'      ).to.differ_from '0,0,255'
    expect('255,0,0'    ).to.differ_from '0,0,255'
    expect('208,32,183' ).to.differ_from '234,134,30'

    expect('81,174,131' ).not.to.differ_from '152,203,178'
    expect('255,0,0'    ).not.to.differ_from '235,0,0'

  it 'detects the colors of The North Borders by Bonobo', (done) ->
    new ColorFinder('http://rdio-b.cdn3.rdio.com/album/4/6/0/00000000002b3064/3/square-500.jpg').analyze (colors) ->
      log_colors(colors)
      done()

  it 'detects rgb(0,0,30) on red', (done) ->
    draw('rgb(0,0,30)', on: 'red')
    new ColorFinder(url()).analyze (colors) ->
      log_colors(colors)
      expect(colors.background).to.equal '255,0,0'
      expect(colors.primary   ).to.equal '0,0,30'
      done()

  it 'detects rgb(255, 0, 0) on white', (done) ->
    draw('rgb(255,0,0)', on: 'white')
    new ColorFinder(url()).analyze (colors) ->
      log_colors(colors)
      expect(colors.background).to.equal '255,255,255'
      expect(colors.primary   ).to.equal '255,0,0'
      done()
