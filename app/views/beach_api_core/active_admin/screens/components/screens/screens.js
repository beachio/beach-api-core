app.directive('screens', ['ngDialog', function(ngDialog){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      list: "=",
      initialScreen: "="
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'screens.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.openSettingsWindow = function (screen) {
          ngDialog.open({
            template: "screens/settings.html",
            controller: ['$scope', function (scope) {
              scope.screen = screen
            }]
          })
        }

      $scope.addScreen = function () {
        $scope.list.push($scope.initialScreen)
      }
    }
  };
}]);