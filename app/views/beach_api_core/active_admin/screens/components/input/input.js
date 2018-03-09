app.directive('sInput', ['ngDialog', function(ngDialog){
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
    templateUrl: 'input.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.openDialog = function () {
        ngDialog.open({
          template: '<h2>Input settings</h2>'
                  + '<label class="label">'
                    + 'Model:&nbsp;'
                    + '<input class="form-control" type="text" ng-model="parentScope.data.model">'
                  + '</label>'
                  + '<label class="label">'
                    + 'Type:&nbsp;'
                    + '<input class="form-control" type="text" ng-model="parentScope.data.type">'
                  + '</label>'
                  + '<label class="label">'
                    + 'Placeholder:&nbsp;'
                    + '<input class="form-control" type="text" ng-model="parentScope.data.placeholder">'
                  + '</label>'
                  + '<br>'
                  + '<label class="label">'
                    + '<input type="checkbox" ng-model="parentScope.data.required"> required'
                  + '</label>'
                  + '<br>'
                  + '<label class="label">'
                    + 'Width, %:&nbsp;'
                    + '<input class="form-control" type="number" ng-model="parentScope.data.width">'
                  + '</label>'
                  + '<hr>'
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