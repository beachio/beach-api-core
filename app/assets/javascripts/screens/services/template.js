app.service('Template', ['User', function(User){
  var Template = this;

  Template.User = User.get()

  Template.random = function (min, max) {
    var rand = Math.floor(min + Math.random()*(max+1 - min))
    return rand;
  }
}])