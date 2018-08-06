app.controller('ScreensCtrl', ['$scope', 'Config', 'Screen', '$timeout', 'Message', function($scope, Config, Screen, $timeout, Message){
  var ctrl = this
  $scope.Screen = Screen
  $scope.Message = Message

  ctrl.sendMessage = (message) => {
    Message.push({from: "user", template: message})
    ctrl.message = ""
  }

  Screen.flow({flow_id: Config.flow_id}, function (res) {
    Screen.push(res)
  })

  $scope.$watch('[Screen.list, Message.list]', function (active, old) {
    $timeout(() => {
      let el = $(".app-layout-body")
      el.animate({ scrollTop: el.height() }, "slow");
    })
  }, true)
}])