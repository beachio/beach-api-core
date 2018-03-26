app.directive('dynamicControl', ['ComponentState', function(ComponentState){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      control: "=",
      controls: "=",
      screen: "="
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    template: '<div><dynamic-element ng-if="content" content="content"></dynamic-element></div>',
    // templateUrl: '',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      var type = $scope.control.type;
      $scope.$watch('control.settings.states', function (states) {
        $scope.componentState = ComponentState.activeState(states);
      }, true)
      $scope.content = "<div><control-actions screen='$parent.screen' controls='$parent.controls' control='$parent.control' controls='controls'></control-actions><mobile-"+type+" state='$parent.componentState'></mobile-"+type+"></div>"

      try {
        iElm.css({width: ($scope.control.settings.width || 100) + '%'})
      } catch(e){}
    }
  };
}]);