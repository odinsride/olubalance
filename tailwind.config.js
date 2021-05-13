const colors = require('tailwindcss/colors')
const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  purge: [
      './app/**/*.html.erb',
      './app/helpers/**/*.rb',
      './app/components/**/*.html.erb',
      './app/javascript/**/*.js',
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      gray: colors.gray,
      green: colors.teal,
      white: colors.white,
    },
    extend: {
      colors: {
        green: {
          75: '#ebf5f3',
        }
      },
      fontFamily: {
        body: ['Mulish']
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
