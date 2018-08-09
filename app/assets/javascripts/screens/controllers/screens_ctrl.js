app.controller('ScreensCtrl', ['$scope', 'Config', 'Screen', '$timeout', 'Message', 'Action', function($scope, Config, Screen, $timeout, Message, Action){
  var ctrl = this
  $scope.Screen = Screen
  $scope.Message = Message

  Screen.bot({uuid: Config.bot_uuid}, (res) => {
    ctrl.bot = res
    Config.bot = res
  })

  ctrl.sendMessage = (message) => {
    if (message) {
      Action.list["DIALOG_FLOW"]({bot_uuid: Config.bot_uuid, message})
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