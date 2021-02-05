const colors = require('tailwindcss/colors')
const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  purge: [],
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
