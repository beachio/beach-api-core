app.directive('renderTemplate', ['$http', '$templateCache', '$compile', '$parse', function($http, $templateCache, $compile, $parse) {
    return function(scope, element, attrs) {
      scope.$watch(function () {
        return $parse(attrs.renderTemplate)(scope)
      }, function (templatePath) {
        var template = $templateCache.get(templatePath);
        var contents = element.html(template).contents();
        $compile(contents)(scope);
      })
    };
}]);