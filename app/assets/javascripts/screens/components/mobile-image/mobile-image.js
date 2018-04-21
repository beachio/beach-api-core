app.directive('mobileImage', ["DataSource", "$compile", function(DataSource, $compile){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      state: "="
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    require: '^screen',
    templateUrl: 'mobile-image.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.screen = controller.screen;
      $scope.DataSource = DataSource;
      $scope.$watch('DataSource', function () {
        var url = $scope.state.url
        if (url) {
          if (url.match(/\{\{.+\}\}/)) {
            $scope.url = _.template($scope.state.url)($scope)
          } else {
            $scope.url = url
          }
        } else {
          $scope.url = $scope.state.image.url;
        }
      }, true)
    }
  };
}]);