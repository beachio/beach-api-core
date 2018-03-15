app.directive('additionalComponent', ['ngDialog', '$rootScope', function(ngDialog, $rootScope){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      ngModel: "="
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'additional-component.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.ngModel = $scope.ngModel || []

      $scope.gridsterOpts = {
          margins: [20, 20],
          mobileBreakPoint: 0,
          resizable: {
              enabled: true,
          },
          draggable: {
              enabled: true,
              handle: '.additional-component__handle'
          }
      }

      $scope.openSettings = function (control) {
        ngDialog.open({
          template: 'additional-component-item.html',
          controller: ['$scope', function (scope) {
            scope.availableControls = _.without($rootScope.allControls, "additional-component")
            scope.control = control
            scope.control.settings = scope.control.settings || {}
            scope.control.settings.list = scope.control.settings.list || []

            scope.save = function () {
              scope.closeThisDialog()
            }
          }]
        })
      }
    }
  };
}]);