app.directive('mobileComponent', ['$compile', 'Template', 'ComponentState', function($compile, Template, ComponentState){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      component: "="
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    // templateUrl: '',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.$watch(function () {
        return [$scope.component.settings.states, Template]
      }, function () {
        if ($scope.component) {
          var states = $scope.component.settings.states
          $scope.componentState = ComponentState.activeState(states);
          try {
            iElm.css({width: ($scope.componentState.width || 100) + '%'})
          } catch(e){}
        }
      }, true)

      var template = "<mobile-"+$scope.component.type+" state='componentState' ng-show='componentState'></mobile-"+$scope.component.type+">"
      iElm.html($compile(template)($scope))
    }
  };
}]);