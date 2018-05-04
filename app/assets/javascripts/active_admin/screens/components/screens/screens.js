app.directive('screens', ['ngDialog', 'Template', function(ngDialog, Template){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      list: "="
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'screens.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.$watchCollection('list', function (list) {
        _.each(list, function (screen, index) {
          screen.position = index;
        })
      })

      $scope.openSettingsWindow = function (screen) {
          ngDialog.open({
            className: "ngdialog-settings",
            template: "screens/settings.html",
            controller: ['$scope', function (scope) {
              scope.screen = angular.copy(screen);
              scope.openHelp = function () {
                ngDialog.open({
                  className: "ngdialog-settings",
                  template: "screens/help.html",
                  controller: ["$scope", function (_scope) {
                    _scope.Template = Template;
                  }]
                })
              }

              scope.save = function () {
                angular.extend(screen, scope.screen);
                scope.closeThisDialog();
              }
            }]
          })
        }

      $scope.addScreen = function () {
        var defaultScreen = {
          header: {},
          body: [],
          footer: [],
          leaderboardTop: [],
          leaderboardBottom: []
        }
        $scope.list.push({content: defaultScreen})
      }
    }
  };
}]);