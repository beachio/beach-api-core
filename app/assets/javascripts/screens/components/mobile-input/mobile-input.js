app.directive('mobileInput', ["Model", "Action", function(Model, Action){
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
    templateUrl: 'mobile-input.html',
    require: '^screen',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.Model = Model;
      $scope.screen = controller.screen;


      var fireAction = function () {
        var action = $scope.state.action
        if (action) {
          if (action) Action.call(action)
        }
      }

      $scope.fireAction = _.debounce(fireAction, 300)
    }
  };
}]);