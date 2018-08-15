app.controller('SingleScreenCtrl', ['$scope', 'Screen', 'Action', function($scope, Screen, Action){
  var ctrl = this
  
  var params = JSON.parse('{"' + decodeURI(window.location.search.replace('?', '').replace(/&/g, "\",\"").replace(/=/g,"\":\"")) + '"}')
  Screen.get({id: params.id, bot_uuid: params.bot_uuid}, (res) => {
    ctrl.screen = res
  })
}])