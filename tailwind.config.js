/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{html,ts}",
  ],
  theme: {
    extend: {
      colors: {
        'europass-blue': '#004494',
        'europass-gray': '#f4f7f9',
      },
      fontFamily: {
        'europass': ['Inter', 'Roboto', 'sans-serif'],
      }
    },
  },
  plugins: [],
}
