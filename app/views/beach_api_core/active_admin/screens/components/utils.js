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

app.directive("contenteditable", function() {
  return {
    restrict: "A",
    require: "ngModel",
    link: function(scope, element, attrs, ngModel) {

      function read() {
        ngModel.$setViewValue(element.html());
      }

      ngModel.$render = function() {
        element.html(ngModel.$viewValue || "");
      };

      element.bind("blur keyup change", function() {
        scope.$apply(read);
      });
    }
  };
});

app.directive('ngBindHtmlCompile', ['$compile', '$filter', function ($compile, $filter) {
  return {
    restrict: 'A',
    link: function (scope, element, attrs) {
      scope.$watch(function () {
        return scope.$eval(attrs.ngBindHtmlCompile);
      }, function (value) {
        element.html(value);
        $compile(element.contents())(scope);
      });
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
          $scope.clickMe = function(){
               alert("hi")
          };
       }]
     }
 }])

app.directive('toJson', function() {
  return {
    require: 'ngModel',
    link: function(scope, elm, attrs, ctrl) {
     ctrl.$formatters.push(JSON.stringify);
    }
  }
});