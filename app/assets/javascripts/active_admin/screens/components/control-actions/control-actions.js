app.directive('controlActions', ['ngDialog', function(ngDialog){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      screen: "=",
      controls: "=",
      control: "="
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    restrict: 'E', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'controls-actions.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.openSettingsWindow = function (control) {
        ngDialog.open({
          template: control.type+'/settings.html',
          controller: ['$scope', function (scope) {
            scope.control = control

            scope.save = function () {
              scope.control.settings.status = "added";
              scope.closeThisDialog();
            }
          }],
          preCloseCallback: function (value) {
            if ($scope.control.settings.status == "new") {
              $scope.controls.pop();
              $scope.$apply();
            }
          }
        })
      }

      if ($scope.control.settings.status == "new")
        $scope.openSettingsWindow($scope.control)
    }
  };
}]);