app.factory('User', ['$resource', function($resource){
  return $resource('/v1/user-info')
}])