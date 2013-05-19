window.img_color = function(img, callback) {
  var canvas = document.createElement("canvas");
  var buckets = {};

  // img.crossOrigin = 'http://cdn3.rd.io/crossdomain.xml';

  img.onload = function() {
      canvas.width = img.width;
      canvas.height = img.height;

      var ctx = canvas.getContext('2d');
      ctx.drawImage(img, 0, 0);

      var pixels = ctx.getImageData(0, canvas.height - 10, canvas.width, 10).data;
      var max = {color: null, value: 0}

      for (var i = 0; i < pixels.length; i += 4) {
          var colors = [];

          for (var j = 0; j < 3; j++) {
              colors.push(Math.round(pixels[i + j] / 2) * 2);
          }
          
          var color = "rgb(" + colors.join(",") + ")";
          buckets[color] || (buckets[color] = 0);
          buckets[color] += 1;

          if (buckets[color] > max.value) {
              max.color = color;
              max.value = buckets[color];
          }
      }
      console.log(max.color, max.value);
      callback(max.color);
  }
}
