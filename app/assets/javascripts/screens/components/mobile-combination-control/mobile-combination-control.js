app.directive('mobileCombinationControl', ['ComponentState', function(ComponentState){
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
    templateUrl: 'mobile-combination-control.html',
    require: '^screen',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.screen = controller.screen;
      $scope.ComponentState = ComponentState;

      $scope.gridsterOpts = {
          margins: [20, 20], // the pixel distance between each widget
          mobileBreakPoint: 0, // if the screen is not wider that this, remove the grid layout and stack the items
          resizable: {
              enabled: false,
          },
          draggable: {
              enabled: false,
          }
      };
    }
  };
}]);