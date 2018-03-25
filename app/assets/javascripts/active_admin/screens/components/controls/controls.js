app.directive('controls', ['ngDialog', function(ngDialog){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      controls: "=",
      availableControls: "=",
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    restrict: 'E', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'controls.html',
    require: '^screen',
    // replace: true,
    transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.screen = controller.screen;
      $scope.openControlSelector = function () {
        ngDialog.open({
          template: 'controls/control-selector.html',
          controller: ['$scope', function (scope) {
            scope.availableControls = $scope.availableControls

            scope.addControl = function (type) {
              $scope.controls.push({
                type: type,
                settings: {
                  status: "new",
                  states: [{
                    list: [],
                    title: "Title"
                  }]
                }
              })

              scope.closeThisDialog();
            }
          }]
        })
      }
    }
  };
}]);