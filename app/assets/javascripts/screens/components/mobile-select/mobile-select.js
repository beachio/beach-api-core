app.directive('mobileSelect', ['Model', function(Model){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      settings: "="
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
      $scope.$watch('settings', function (settings) {
        if (settings && settings.list && settings.list[0]) {
          $scope.activeItem = settings.list[0].label;
        }
      }, true)

      $scope.setActiveItem = function () {
        var index = _.pluck($scope.settings.list, 'label').indexOf($scope.activeItem)

        if (index >= $scope.settings.list.length-1)
          index = 0;
        else
          index = index + 1;
        
        $scope.activeItem = $scope.settings.list[index].label;
      }
    }
  };
}]);