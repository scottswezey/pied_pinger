const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  // purge: {
  //   layers: ['components', 'utilities'],
  //   content: [
  //     '../lib/**/*.ex',
  //     '../lib/**/*.leex',
  //     '../lib/**/*.eex',
  //     './js/**/*.js'
  //   ]
  // },
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      sans: ['Inter var', ...defaultTheme.fontFamily.sans],
    },
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
