app.directive('dynamicControl', [function(){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      control: "="
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    template: '<dynamic-element ng-if="content" content="content"></dynamic-element>',
    // templateUrl: '',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      try {
        iElm.css({width: ($scope.control.settings.width || 100) + '%'})
      } catch(e){}

      var type = $scope.control.type;
      $scope.content = "<mobile-"+type+" settings='$parent.control.settings'></mobile-"+type+">"
    }
  };
}]);