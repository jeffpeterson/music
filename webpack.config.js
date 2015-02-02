var webpack = require('webpack')

module.exports = {
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
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin(),
  ],
  devServer: {
    hot: true,
    stats: { colors: true }
  },
  module: {
    loaders: [
      { test: /\.js$/, exclude: /node_modules/, loaders: ['6to5-loader', 'react-hot']}
    ]
  }
}
