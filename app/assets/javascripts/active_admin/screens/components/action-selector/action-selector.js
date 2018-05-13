app.directive('actionSelector', ['$compile', 'ngDialog', function($compile, ngDialog){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      ngModel: "=",
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'action-selector.html',
    replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    compile: function(tElement, tAttr, transclude) {
      var contents = tElement.contents().remove();
      var compiledContents;
      return function(scope, iElement, iAttr) {

        if(!compiledContents) {
            compiledContents = $compile(contents, transclude);
        }
        compiledContents(scope, function(clone, scope) {
           iElement.append(clone); 
        });
      };
    },
    controller: ['$scope', function($scope) {
      $scope.availableActions = ['GO_TO_SCREEN_BY_ID', 'OPEN_FLOW', 'NEXT_SCREEN', 'PREV_SCREEN', 'SUBMIT_ON_SERVER', 'SOCIAL_NETWORKS_ACTION', 'OPEN_MENU', 'OPEN_MODAL', 'OPEN_WEBVIEW', 'OPEN_CAMERA', 'OPEN_GALLERY', 'OPEN_APP', 'SIGN_OUT']

      $scope.$watch('ngModel.type', function (type, old) {
        if (type && old && type != old)
          $scope.ngModel = {type: type}
      })

      $scope.openModalBody = function (payload) {
        if (!payload) payload = {}

        ngDialog.open({
          template: 'action-selector/open-modal-body.html',
          className: 'ngdialog-open-modal-settings ngdialog-settings',
          controller: ['$scope', function (scope) {
            scope.payload = angular.copy(payload)

            scope.save = function () {
              _.extend(payload, scope.payload);
              scope.closeThisDialog();
            }
          }]
        })
      }
    }]
  };
}]);