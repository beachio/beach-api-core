app.directive('controls', [function(){
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
          data: {
            list: [],
            title: "Title"
          }
        })
      }

      $scope.getContentByType = function (type) {
        return "<s-"+type+" data='$parent.control.data' ng-model='$parent.control.model'></c-"+type+">"
      }
    }
  };
}]);