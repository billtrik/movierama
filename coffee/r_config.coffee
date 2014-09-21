requirejs.config({
  baseUrl: 'js',
  paths: {
    'lodash': 'vendor/lodash',
    'jquery': 'vendor/jquery'
  },
  shim: {
    'lodash': {
      exports: '_'
    },
    'jquery': {
      exports: '$'
    }
  }
});