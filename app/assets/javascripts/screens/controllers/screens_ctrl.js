app.controller('ScreensCtrl', ['$scope', 'Config', 'Screen', '$timeout', 'Message', function($scope, Config, Screen, $timeout, Message){
  var ctrl = this
  $scope.Screen = Screen
  $scope.Message = Message

  Screen.get({id: Config.flow_id}, function (res) {
    Screen.active = res
  })

  $scope.$watch('[Screen.active, Message.list]', function (active, old) {
    $timeout(function () {
      document.body.scrollTop = document.body.scrollHeight
    })
  }, true)
}])