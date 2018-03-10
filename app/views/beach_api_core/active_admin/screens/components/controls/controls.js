app.directive('controls', ['ngDialog', function(ngDialog){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      controls: "=",
      types: "=",
      models: "=",
      cube: "="
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'screen_controls.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.addControl = function (type) {
        $scope.controls.push({
          type: type,
          settings: {
            list: [],
            title: "Title"
          }
        })
      }

      $scope.openSettingsWindow = function (control) {
        ngDialog.open({
          template: control.type+'/settings.html',
          controller: ['$scope', function (scope) {
            scope.control = control
          }]
        })
      }

      $scope.getContentByType = function (type) {
        return "<s-"+type+" settings='$parent.control.settings' ng-model='$parent.control.model'></c-"+type+">"
      }
    }
  };
}]);