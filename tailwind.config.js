/** @type {import('tailwindcss').Config} */
const defaultTheme = require('tailwindcss/defaultTheme');
const colors = require('tailwindcss/colors');

module.exports = {
  content: [
    './app/views/**/*.{slim,erb,jbuilder,turbo_stream,js}',
    './app/components/**/*.{slim,erb,jbuilder,turbo_stream,js}',
    './app/decorators/**/*.rb',
    './app/helpers/**/*.rb',
    './app/inputs/**/*.rb',
    './app/assets/javascripts/**/*.js',
    './config/initializers/**/*.rb',
    './lib/components/**/*.rb',
  ],
safelist: [
    // {
    //   pattern: /bg-(red|green|blue|orange)-(100|200|400)/,
    // },
    // {
    //   pattern: /text-(red|green|blue|orange)-(100|200|400)/,
    // },
    'pagy-*',
  ],
  variants: {
    extend: {
      overflow: ['hover'],
    },
  },
  darkMode: 'class',
  theme: {
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      black: colors.black,
      white: colors.white,
      primary: colors.zinc,
      secondary: colors.zinc,
      accent: colors.teal,
      danger: colors.rose,
      midnight: {
        100: '#edf1fc',
        700: '#222c42',
        900: '#0f172a',
      },
    },
    fontFamily: {
      sans: ['Inter var', ...defaultTheme.fontFamily.sans],
    },
    listStyleType: {
      none: 'none',
      disc: 'disc',
      decimal: 'decimal',
      square: 'square',
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography')
  ],
}

