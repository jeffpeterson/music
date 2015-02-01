module.exports = {
  entry: {
    app: ['webpack/hot/dev-server', './index.js']
  },
  output: {
    path: __dirname,
    filename: 'bundle.js'
  },
  module: {
    loaders: [
      { test: /\.js$/, exclude: /node_modules/, loader: '6to5-loader'}
    ]
  }
}
