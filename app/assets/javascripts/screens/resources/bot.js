app.factory('Bot', ['$resource', 'Config', function($resource, Config){
  return $resource('/v1/bots', {bot_uuid: Config.bot_uuid}, {
    dialog_flow: {
      "method": "POST",
      "url": "/v1/bots/dialog_flow",
    }
  })
}])