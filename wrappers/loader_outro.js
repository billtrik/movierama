global.requirejs = requirejs;
global.require = require;
global.define = define;

require(['application'], function(App){
  new App();
})

})(this)