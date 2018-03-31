app.directive('autocompleteSelect', ['$http', function($http){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      ngModel: "="
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'autocomplete-select.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.placeholder = iAttrs.placeholder;
      $scope.filterField = iAttrs.filterField;
      $scope.searchText = "";

      $scope.setModel = function(selectedItem){
        $scope.ngModel = _.isObject(selectedItem) ? selectedItem.id : selectedItem;
      }

      $scope.$watch(function () {
        return iAttrs.url
      }, function (url) {
        $http.get(url).then(function (res) {
          $scope.items = res.data;
          if ($scope.ngModel) {
            if (_.isObject($scope.items[0]))
              $scope.selectedItem = _.findWhere($scope.items, {id: $scope.ngModel})
            else
              $scope.selectedItem = $scope.ngModel
          }
        })
      })
      $scope.querySearch = function (query) {
        if (!query) return $scope.items;

        return _.select($scope.items, function (item) {
          if ($scope.filterField) {
            return item[$scope.filterField].toLowerCase().indexOf(query.toLowerCase()) != -1
          } else {
            return item.toLowerCase().indexOf(query.toLowerCase()) != -1
          }
        })
      }
    }
  };
}]);