const { environment } = require('@rails/webpacker')

environment.module = {
  rules: [
    {
      test: /\.(png|woff|woff2|eot|ttf|svg)$/,
      use: [
        {
          loader: 'url-loader',
          limit: '100000'
        }
      ]
    }
  ]
}
module.exports = environment
