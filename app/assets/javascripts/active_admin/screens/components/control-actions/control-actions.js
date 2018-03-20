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
    require: '^screen',
    templateUrl: 'controls-actions.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.screen = controller.screen;
      $scope.openSettingsWindow = function (control) {
        ngDialog.open({
          template: control.type+'/settings.html',
          className: ['ngdialog-settings', 'ngdialog-settings-'+control.type].join(" "),
          controller: ['$scope', function (scope) {
            scope.control = angular.copy(control)

            scope.save = function () {
              scope.control.settings.status = "added";
              _.extend(control, scope.control);
              scope.closeThisDialog();
            }
          }],
          closeByDocument: false,
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