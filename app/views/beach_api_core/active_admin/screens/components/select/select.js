app.directive('sSelect', ['ngDialog', function(ngDialog){
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
    templateUrl: 'select.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.openDialog = function () {
        ngDialog.open({
          template: '<h2>Select settings</h2>'
                    + '<label class="label block" ng-repeat="option in parentScope.data.list">'
                      + '{{$index+1}}:&nbsp;'
                      + '<input class="form-control" type="text" ng-model="option.label">'
                    + '</label>'
                   
                    + '<a ng-click="parentScope.data.list.push({})">Add option</a>'
                    + '<br>'
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