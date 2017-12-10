var webpack = require('webpack')

module.exports = {
  devtool: "source-map",
  entry: [
  'webpack-dev-server/client?http://0.0.0.0:4321',
  './src/index.js'
  ],
  output: {
    path: __dirname,
    filename: 'bundle.js'
  },

  plugins: [
    new webpack.NoErrorsPlugin(),
  ],

  resolve: {
    root: `${__dirname}/src`,
  },

  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules\/(?!(immutable-devtools)\/).*/,
        loader: 'babel-loader',
        query: {
          cacheDirectory: true,
        }
      }
    ]
  }
}
