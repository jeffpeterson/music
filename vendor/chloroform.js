(function(base){

base.Chloroform = function(imageUrl, options) {
  var o;

  o = this.options = options || {};

  o.count     || (o.count     = 3);
  o.subsample || (o.subsample = 0);

  this.imageUrl          = imageUrl;
  this.colors            = {};
  this.canvas            = document.createElement('canvas');
  this.canvas.width      = this.width;
  this.canvas.height     = this.height;
  this.ctx               = this.canvas.getContext('2d');
  this.image             = new Image();

  if (!/^data:/.test(this.imageUrl)) {
    this.image.crossOrigin = "anonymous";
  }
}

base.Chloroform.prototype = {
  width:    100,
  height:   100,

  afterImageLoads: function(fn) {
    this.image.onload = fn.bind(this);
    this.image.src    = this.imageUrl;

    return this;
  },

  analyze: function(callback) {
    this.afterImageLoads(function(){
      this.analyzeNow();
      callback && callback(this.colors);
    });

    return this;
  },

  analyzeNow: function() {
    var colors, lastFoundColor;

    this.ctx.drawImage(this.image, 0, 0, this.width, this.height);

    this.colors.background = this.findBackground();
    this.colors.contrast   = this.isDark(this.colors.background) ? '255,255,255' : '0,0,0';
    lastFoundColor         = this.colors.contrast;

    colors = this.findColors(this.imageData(), {subsample: 1});

    for (var i = 0; i < this.options.count; i++) {
      lastFoundColor = this.colors[i] = colors[i] || lastFoundColor;
    }

    return this;
  },

  imageData: function(left, top, width, height) {
    left   || (left   = 0);
    top    || (top    = 0);
    width  || (width  = this.width);
    height || (height = this.height);

    return this.ctx.getImageData(left, top, width, height).data;
  },

  findBackground: function(size, offset) {
    var edgePixels;

    size   || (size   = 1);
    offset || (offset = 0);

    edgePixels = [];

    // top
    [].push.apply(edgePixels, this.imageData(
      offset,
      offset,
      this.width - offset * 2,
      size
    ));

      // right
    [].push.apply(edgePixels, this.imageData(
      this.width - offset - size,
      offset,
      size,
      this.height - offset * 2
    ));

      // bottom
    [].push.apply(edgePixels, this.imageData(
      offset,
      this.height - offset - size,
      this.width - offset * 2,
      size
    ));

    // left
    [].push.apply(edgePixels, this.imageData(
      offset,
      offset,
      size,
      this.height - offset * 2
    ));

    return this.findColors(edgePixels, { count: 1 })[0]
  },

  findColors: function(pixels, options) {
    var numberOfColors, diff, stepSize, subsample, counts, groupedCounts;

    options || (options = {});

    numberOfColors = options.count         || 3;
    diff           = options.startDistance || 0;
    stepSize       = options.stepBy        || 500;
    subsample      = options.subsample     || 0;

    counts = groupedCounts = this.countColors(pixels, subsample);

    for (var i = 0; i < 10; i++) {
      if (Object.keys(counts).length <= numberOfColors) break;

      counts = groupedCounts;
      groupedCounts = this.groupColorsByCount(counts, diff += stepSize);
    }

    return this.colorsSortedByCount(counts);
  },

  countColors: function(pixels, subsample) {
    var counts, step, key, rgb;

    counts = {};
    step = 4 * (subsample + 1);

    for (var i = 0; i < pixels.length; i += step) {
      rgb = [pixels[i], pixels[i + 1], pixels[i + 2]];

      if (this.colors.background && !this.contrastsBackground(rgb)) continue;

      key = rgb.join(',');

      counts[key] || (counts[key] = 0);
      counts[key]  += 1;
    }

    return counts;
  },

  colorsSortedByCount: function(counts) {
    return Object.keys(counts).sort(function(a, b) {
      return counts[b] - counts[a];
    });
  },

  groupColorsByCount: function(counts, diff) {
    var groups, colors, i, j;

    groups = {};
    colors = this.colorsSortedByCount(counts);
    i      = 0;

    while (bucket = colors[i++]) {
      groups[bucket] = counts[bucket];
      j = i;

      while (colors[j]) {
        if (this.areDiffering(bucket, colors[j], diff)) {
          j++;
        } else {
          groups[bucket] += counts[colors[j]];
          colors.splice(j, 1);
        }
      }
    }

    return groups;
  },


  ybr: function(rgb) {
    if (typeof rgb === 'string') return this.ybr(rgb.split(','));

    r = rgb[0];
    g = rgb[1];
    b = rgb[2];

    y  =       (0.299    * r) + (0.587    * g) + (0.114    * b);
    cb = 128 - (0.168736 * r) - (0.331264 * g) + (0.5      * b);
    cr = 128 + (0.5      * r) - (0.418688 * g) - (0.081312 * b);

    return [y, cb, cr];
  },

  distanceSquared: function(a, b) {
    var sum;

    a   = this.ybr(a);
    b   = this.ybr(b);

    sum  = Math.pow(a[0] - b[0], 2);
    sum += Math.pow(a[1] - b[1], 2);
    sum += Math.pow(a[2] - b[2], 2);

    return sum;
  },

  areDiffering: function(a, b, diff) {
    diff || (diff = 3000)
    return this.distanceSquared(a, b) > diff;
  },

  isDark: function(color) {
    return this.ybr(color)[0] < 127;
  },

  areContrasting: function(a, b, diff) {
    diff || (diff = 75)
    return Math.abs(this.ybr(a)[0] - this.ybr(b)[0]) > diff;
  },

  contrastsBackground: function(colorKey) {
    return this.areContrasting(this.colors.background, colorKey);
  }
}

Chloroform.analyze = function(imageUrl, options, callback) {
  if (!callback) {
    callback = options;
    options  = {};
  }

  return new Chloroform(imageUrl, options).analyze(callback);
}

})(this);
