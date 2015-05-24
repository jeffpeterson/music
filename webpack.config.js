var webpack = require('webpack')

module.exports = {
  devtool: "source-map",
  entry: [
  'webpack-dev-server/client?http://0.0.0.0:4321',
  'webpack/hot/only-dev-server',
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
      { test: /\.js$/, exclude: /node_modules/, loaders: ['react-hot', 'babel-loader?stage=0']}
    ]
  }
}
