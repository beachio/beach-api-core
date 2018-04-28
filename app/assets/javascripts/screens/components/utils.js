app.directive('clickOutside', ['$document', function ($document) {
  return {
    restrict: 'A',
    scope: {
      clickOutside: '&',
      clickOutsideIf: '='
    },
    link: function (scope, el, attr) {
      var handler = function (e) {
        if (scope.clickOutsideIf && el !== e.target && !el[0].contains(e.target) && document.body.contains(e.target)) {
          scope.$apply(function () {
              scope.$eval(scope.clickOutside);
          });
        }
      }

      $document.bind('click', handler);

      scope.$on('$destroy', function () {
        $document.unbind('click', handler)
      })
    }
  }
}])

app.directive('ngBindHtmlCompile', ['$compile', '$filter', 'Template', function ($compile, $filter, Template) {
  return {
    restrict: 'A',
    link: function (scope, element, attrs) {
      scope.$watch(function () {
        return [scope.$eval(attrs.ngBindHtmlCompile), Template];
      }, function (value) {
        _.extend(scope, Template);
        element.html(value[0]);
        $compile(element.contents())(scope);
      }, true);
    }
  };
}]);

app.directive('dynamicElement', ['$compile', function ($compile) {
     return { 
       restrict: 'E',
       scope: {
           content: "="
       },
       replace: true,
       link: function(scope, element, attrs) {
           var template = $compile(scope.content)(scope);
           element.replaceWith(template);               
       },
       controller: ['$scope', function($scope) {

       }]
     }
 }])
