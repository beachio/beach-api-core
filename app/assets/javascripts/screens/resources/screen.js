app.factory('Screen', ['$resource', function($resource){
  return $resource('/screens/:id', {"id":"@id"}, {
    "next": {
      "method": "GET",
      "url": "/screens/:id/next"
    },
    "prev": {
      "method": "GET",
      "url": "/screens/:id/prev"
    },
    "flow": {
      "method": "GET",
      "url": "/screens/flow"
    },
    "main_flow": {
      "method": "GET",
      "url": "/screens/main_flow"
    },
  })
}])