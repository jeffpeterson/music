var webpack = require('webpack')

module.exports = {
  devtool: "source-map",
  entry: [
    './index.js'
  ],
  output: {
    path: __dirname,
    filename: 'bundle.js'
  },

  plugins: [
    new webpack.NoErrorsPlugin(),
  ],

  resolve: {
    root: __dirname,
  },

  module: {
    loaders: [
      { test: /\.js$/, exclude: /node_modules/, loaders: ['babel-loader?experimental']}
    ]
  }
}
