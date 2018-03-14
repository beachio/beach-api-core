app.directive('controls', ['ngDialog', function(ngDialog){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      screen: "=",
      controls: "=",
      availableControls: "=",
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    restrict: 'E', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'controls.html',
    // replace: true,
    transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
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
                  list: [],
                  title: "Title"
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