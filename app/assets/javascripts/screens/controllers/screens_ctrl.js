app.controller('ScreensCtrl', ['$scope', '$state', 'Screen', function($scope, $state, Screen){
  var ctrl = this;

  var id = parseInt($state.params.id);

  if (id) {
    Screen.get({id: id}, function (res) {
      ctrl.screen = res;
    })
  } else {
    ctrl.screen = {
      content: {
        header: {
          description: "Home"
        }
      }
    }
  }

}])