app.service('Template', ['User', function(User){
  var Template = this;

  Template.reloadTemplate = function (callback) {
    User.get(function (res) {
      Template.User = res;
      Template.loaded = true;
    })
  }
}])