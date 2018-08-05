app.directive('mobileItemsInARow', ['Action', '$timeout', 'ComponentState', function(Action, $timeout, ComponentState){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      state: "="
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    require: '^?screen',
    // template: '',
    templateUrl: 'mobile-items-in-a-row.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      if (controller)
        $scope.screen = controller.screen;
      $scope.ComponentState = ComponentState;
      
      $scope.fireAction = function (action) {
        if (action)
          Action.call(action)
      }

      $scope.$watch('state', function () {
        $scope.rebuild = true;
        $timeout(function () {
          $scope.rebuild = false;
        })
      }, true)
    }
  };
}]);