app.factory('Screen', ['$resource', 'Config', function($resource, Config){

  var Screen = $resource('/v1/screens/:id', {"id":"@id", application_uid: Config.application_uid}, {
    "next": {
      "method": "GET",
      "url": "/v1/screens/:id/next",
    },
    "prev": {
      "method": "GET",
      "url": "/v1/screens/:id/prev",
    },
    "flow": {
      "method": "GET",
      "url": "/v1/screens/flow",
    },
    "main_flow": {
      "method": "GET",
      "url": "/v1/screens/main_flow",
    },
  })

  Screen.active = null
  Screen.messages = []

  return Screen
}])