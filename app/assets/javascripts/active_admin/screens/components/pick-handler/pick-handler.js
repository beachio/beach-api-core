app.directive('pickHandler', ['ngDialog', '$http', function(ngDialog, $http){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      ngModel: "=",
      handlerParams: "="
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'pick-handler.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.handlers = {}
      $http.get('/admin/endpoints/handlers')
           .then(function (res) {
              $scope.handlersByIds = _.indexBy(res.data, 'id')
              _.extend($scope.handlers, _.groupBy(res.data, 'type'));
              $scope.handlerParams = $scope.handlersByIds[$scope.ngModel];
           })

      $scope.openModal = function () {
        ngDialog.open({
          template: 'pick-handler-modal.html',
          className: 'ngdialog-open-modal-settings ngdialog-settings',
          controller: ['$scope', function (scope) {
            scope.handlers = $scope.handlers;
            scope.pickHandler = function (handler) {
              $scope.ngModel = handler.id;
              $scope.handlerParams = handler;
              scope.closeThisDialog();
            }
          }]
        })
      }
    }
  };
}]);