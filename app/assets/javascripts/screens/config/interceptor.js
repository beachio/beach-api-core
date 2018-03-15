app.factory('responseInterceptor', ['$q', function($q) {
  var responseInterceptor = {
    response: function(response) {
      if (_.isObject(response.data)) {
        var str = JSON.stringify(response.data);
        var replacedStr = str.replace(/\{((\w+|\.)+)\}/g, "{{$root.$1}}");
        response.data = JSON.parse(replacedStr);
      }
      return response
    }
  };

  return responseInterceptor;
}]);

app.config(['$httpProvider', function($httpProvider) {
    $httpProvider.interceptors.push('responseInterceptor');
}]);