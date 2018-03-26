app.service('Template', ['User', function(User){
  var Template = this;

  Template.reloadTemplate = function (callback) {
    User.get(function (res) {
      Template.User = res;
      Template.loaded = true;
    })
  }

  Template.random = function (min, max) {
    var rand = Math.floor(min + Math.random()*(max+1 - min))
    return rand;
  }
}])