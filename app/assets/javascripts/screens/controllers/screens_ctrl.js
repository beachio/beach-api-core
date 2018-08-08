app.controller('ScreensCtrl', ['$scope', 'Config', 'Screen', '$timeout', 'Message', function($scope, Config, Screen, $timeout, Message){
  var ctrl = this
  $scope.Screen = Screen
  $scope.Message = Message

  ctrl.bot = Screen.bot({uuid: Config.bot_uuid})

  ctrl.sendMessage = (message) => {
    if (message) {
      Message.push({from: "user", template: message})
      ctrl.message = ""
    }
  }

  Screen.flow({bot_uuid: Config.bot_uuid}, function (res) {
    Screen.push(res)
  })

  $scope.$watch('[Screen.list, Message.list]', function (active, old) {
    $timeout(() => {
      let el = $(".app-layout-body")
      el.animate({ scrollTop: el[0].scrollHeight }, "slow");
    })
  }, true)
}])