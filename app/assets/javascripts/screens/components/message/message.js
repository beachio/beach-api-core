app.directive('message', ['Model', '$interpolate', function(Model, $interpolate){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
        message: "="
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    restrict: 'E', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    // require: '^screen',
    templateUrl: 'message.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.template = $interpolate($scope.message.template)({Model: Model})

      $scope.Model = Model
    }
  };
}]);
