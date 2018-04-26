app.directive('mobileHeader', ['Action', 'Template', 'ComponentState', function(Action, Template, ComponentState){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      header: "="
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    require: '^screen', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'mobile-header.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.Action = Action;
      $scope.screen = controller.screen;
      $scope.$watch('header.descriptions', function () {
        if (!$scope.header.description_type && $scope.header.descriptions && $scope.header.descriptions.length) {
            $scope.description = $scope.header.descriptions[randomInteger(0, $scope.header.descriptions.length-1)].text
        }
      }, true)

      $scope.$watch(function () {
        return [$scope.header.states, Template]
      }, function () {
        if ($scope.header.descriptionsType == "states") {
          var states = $scope.header.states;
          $scope.activeState = ComponentState.activeState(states);
          $scope.description = $scope.activeState.description
        }
      }, true)
    }
  };
}]);

function randomInteger(min, max) {
  var rand = min - 0.5 + Math.random() * (max - min + 1)
  rand = Math.round(rand);
  return rand;
}