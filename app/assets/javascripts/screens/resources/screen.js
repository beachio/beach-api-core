app.factory('Screen', ['$resource', function($resource){
  return $resource('/screens/:id', {"id":"@id"}, {
    "next": {
      "method": "GET",
      "url": "/screens/:id/next"
    }
  })
}])