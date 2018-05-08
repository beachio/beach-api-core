app.directive('mobileCheckboxList', ['Model', 'DataSource', function(Model, DataSource){
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
    templateUrl: 'mobile-checkbox-list.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.Model = Model;
      $scope.screen = controller.screen;
      $scope._ = _;
      var list = $scope.state.list;

      $scope.$watch(function () {
        return DataSource[$scope.state.dataSource]
      }, function (dataSource) {
        $scope.state.list = _.union(dataSource || [], list)
        var ids = _.pluck($scope.state.list, "id")
        $scope.afterSearch = _.select(Model.data[$scope.state.model], function (el) {
          return ids.indexOf(el.id) == -1
        }) || []
      }, true)
    }
  };
}]);


app.directive('mobileCheckboxListItem', [function(){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    // scope: {}, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'mobile-checkbox-list-item.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      
    }
  };
}]);