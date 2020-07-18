const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const path = require('path');
const MODE = process.env.NODE_ENV || "development";
const enabledSourceMap = MODE === "development";

const debugMode = MODE === "development";

const output = MODE === 'development' ? ({
  filename: 'app.js',
  path: path.join(__dirname, '../public')
}) : ({
  filename: 'app.[contentHash].js',
  path: path.join(__dirname, '../dist')
});

const plugins = MODE === 'development' ? [
] : [
  new HtmlWebpackPlugin({
    template: path.join(__dirname, '../public/index.html')
  }),
  new webpack.DefinePlugin({
      API_ENDPOINT: JSON.stringify(process.env.API_ENDPOINT),
  })
];

module.exports = {
  mode: 'development',
  entry: './src/app.js',
  module: {
    rules: [
      {
        test: /(\.css|\.scss)/,
        include: [/node_modules/],
        use: [
          "style-loader",
          {
            loader: "css-loader",
            options: {
              url: false,
              sourceMap: enabledSourceMap,
              importLoaders: 2,
            }
          }
        ]
      },
      {
        test: /(\.css|\.scss)/,
        include: [/src\/styles/],
        use: [
          "style-loader",
          {
            loader: "css-loader",
            options: {
              url: false,
              sourceMap: enabledSourceMap,
              importLoaders: 2
            }
          },
          {
            loader: "sass-loader",
            options: {
              sourceMap: enabledSourceMap
            }
          }
        ]
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader: 'elm-webpack-loader',
          options: {
              debug: debugMode
          }
        }
      },
      {
        test: /\.(yml|yaml)$/,
        use: [
          {
            loader: require.resolve('json-loader')
          },
          {
            loader: require.resolve('yaml-loader')
          }
        ]
      }
    ]
  },
  output,
  plugins,
  devServer: {
    historyApiFallback: true,
    port: 8180,
  }
};

if (MODE !== 'production') {
  module.exports.devtool = 'inline-source-map';
}

