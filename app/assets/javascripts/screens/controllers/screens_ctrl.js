app.controller('ScreensCtrl', ['$scope', 'Config', 'Screen', '$timeout', 'Message', function($scope, Config, Screen, $timeout, Message){
  var ctrl = this
  $scope.Screen = Screen
  $scope.Message = Message

  Screen.flow({flow_id: Config.flow_id}, function (res) {
    Screen.push(res)
  })

  $scope.$watch('[Screen.list, Message.list]', function (active, old) {
    postMessage()
  }, true)
  postMessage()

  function postMessage () {
    $timeout(function () {
      document.body.scrollTop = document.body.scrollHeight

      if (window.sourceEvent) {
        window.sourceEvent.postMessage({
          height: $('.app-layout').height()
        }, window.originEvent);
      }
    })
  }
}])