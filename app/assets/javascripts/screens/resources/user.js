app.factory('User', ['$resource', function($resource){
  return $resource('/mixfit-core/v1/user-info')
}])