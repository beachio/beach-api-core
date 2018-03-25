app.directive('mobileSelect', ['Model', function(Model){
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
    templateUrl: 'mobile-select.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.screen = controller.screen;
      $scope.$watch('state', function (state) {
        if (state && state.list && state.list[0]) {
          $scope.activeItem = state.list[0].label;
        }
      }, true)

      $scope.setActiveItem = function () {
        var index = _.pluck($scope.state.list, 'label').indexOf($scope.activeItem)

        if (index >= $scope.state.list.length-1)
          index = 0;
        else
          index = index + 1;
        
        $scope.activeItem = $scope.state.list[index].label;
      }
    }
  };
}]);