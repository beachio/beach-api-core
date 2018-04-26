app.service('Template', ['User', 'DataSource', function(User, DataSource){
  var Template = this;

  Template.reloadTemplate = function (callback) {
    User.get(function (res) {
      Template.User = res;
      Template.loaded = true;
    })
    Template.DataSource = DataSource;
  }
}])