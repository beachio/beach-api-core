app.directive('mobileButton', ['Action', 'ComponentState', 'Model', function(Action, ComponentState, Model){
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
    // template: '',
    require: '^screen',
    templateUrl: 'mobile-button.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.screen = controller.screen;
      iElm.bind('click', function () {
        if ($scope.state.model) Model[$scope.state.model] = $scope.state.value;
        Action.call($scope.state.action)
      })
    }
  };
}]);
