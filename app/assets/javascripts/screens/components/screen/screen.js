app.directive('screen', ['Action', '$timeout', 'Template', function(Action, $timeout, Template){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      screen: "=",
      disabled: "="
    }, // {} = isolate, true = child, false/undefined = no change
    controller: ['$scope', function($scope) {
      var ctrl = this;
      ctrl.screen = $scope.screen;
    }],
    controllerAs: "ctrl",
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    restrict: 'E', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'screen.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.$watch('screen', function () {
        var settings = $scope.screen.settings;

        Template.reloadTemplate();
        $scope.Template = Template;

        if (settings && settings.rotator) {
          $timeout(function () {
            Action.call($scope.screen.settings.rotation_action || {type: "NEXT_SCREEN"})
          }, settings.rotation_delay)
        }
      }, true)
    }
  };
}]);