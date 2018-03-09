app.directive('sButton', ['ngDialog', function(ngDialog){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      data: "="
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'button.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.openDialog = function () {
        ngDialog.open({
          template: '<h2>Button settings</h2>'
                    + '<label class="label">'
                      + 'Label: <br/>'
                      + '<div><input class="form-control" type="text" ng-model="parentScope.data.label"></div>'
                    + '</label>'
                    + '<label class="label">'
                      + 'Action (NEXT_SCREEN, DO_SOMETHING, etc): <br/>'
                      + '<div><input class="form-control" type="text" ng-model="parentScope.data.action"></div>'
                    + '</label>'
                    + '<label class="label">'
                      + 'Width, %:&nbsp;'
                      + '<input class="form-control" type="number" ng-model="parentScope.data.width">'
                    + '</label>'
                    + '<div class="text-right"><button ng-click="closeThisDialog()">Save</button></div>'
                    + '',
          plain: true,
          controller: ['$scope', function (scope) {
            scope.parentScope = $scope
          }]
        })
      }
    }
  };
}]);