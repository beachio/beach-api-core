app.service('Template', ['User', function(User){
  var Template = this;

  Template.User = User.get()
}])