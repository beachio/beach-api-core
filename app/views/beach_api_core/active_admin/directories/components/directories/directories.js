app.directive('directories', ['$http', 'ngDialog', function($http, ngDialog){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: true, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'directories.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.toggleDirectory = function (directory) {
        if ($scope.isOpenDirectory(directory)) {
          $scope.closeDirectory(directory)
        } else {
          $scope.openDirectory(directory)
        }
      }

      $scope.openDirectory = function (directory) {
        var open_directories = readFromLocalstore("open_directories") || [];
        if (open_directories.indexOf(directory.id)==-1)
          open_directories.push(directory.id);
        directory.open = true;
        writeToLocalstore("open_directories", open_directories);
      }

      $scope.closeDirectory = function (directory) {
        var open_directories = readFromLocalstore("open_directories") || [];
        open_directories = _.without(open_directories, directory.id)
        directory.open = false;
        writeToLocalstore("open_directories", open_directories);
      }

      $scope.isOpenDirectory = function (directory) {
        if (directory.open) {
          return true
        }
        var open_directories = readFromLocalstore("open_directories") || [];
        return open_directories.indexOf(directory.id) != -1
      }

      $scope.openNew = function (type, directory) {
        ngDialog.open({
          template: 'new_edit_form.html',
          controller: ['$scope', function (scope) {
            scope.parentScope = $scope;
            scope.type = type;
            scope.action = 'New';
            scope.model = {
              parent_id: directory.id,
              directory_id: directory.id
            }

            scope.save = function () {
              var promise;
              if (type == 'directory')
                promise = $http.post(window.location.pathname+'/directories', {directory: scope.model || {}})
              if (type == 'flow')
                promise = $http.post(window.location.pathname+'/flows', {flow: scope.model || {}})
                

              promise.then(function () {
                $scope.updateList()
                $scope.openDirectory(directory)
                scope.closeThisDialog()
              })
            }
          }]
        })
      }

      $scope.openEdit = function (type, entity) {
        ngDialog.open({
          template: 'new_edit_form.html',
          controller: ['$scope', function (scope) {
            scope.parentScope = $scope;
            scope.type = type;
            scope.action = 'Edit';
            scope.model = {
              name: entity.name
            }

            scope.save = function () {
              var promise;
              if (type == 'directory')
                promise = $http.put(window.location.pathname+'/directories', {id: entity.id, directory: scope.model || {}})
              if (type == 'flow')
                promise = $http.put(window.location.pathname+'/flows', {id: entity.id, flow: scope.model || {}})


              promise.then(function () {
                $scope.updateList()
                scope.closeThisDialog()
              })
            }
          }]
        })
      }

      $scope.updateList = function () {
        $http.get(window.location.pathname+'/directories')
          .then(function (res) {
            $scope.directories = res.data;
          })
        $http.get(window.location.pathname+'/flows', {params: {main: true}})
          .then(function (res) {
            $scope.main_flow = res.data;
          })
      }

      $scope.delete = function (type, entity) {
        var promise,
            ask = true;
        if (type == 'directory' && (entity.directories.length || entity.flows.length)) {
          ask = confirm("Directory contains directories or flows. Are you sure?");
        }
        if (type == 'flow') {
          ask = confirm("Are you sure?")
        }

        if (type == 'directory' && ask)
          promise = $http.delete(window.location.pathname+'/directories', {params: {id: entity.id}})

        if (type == 'flow' && ask)
          promise = $http.delete(window.location.pathname+'/flows', {params: {id: entity.id}})

        if (promise) {
          promise.then(function () {
            $scope.updateList()
          })
        }
      }

      $scope.updateList()

    }
  };
}]);


function writeToLocalstore(key, obj) {
  localStorage.setItem(key, JSON.stringify(obj));
}

function readFromLocalstore(key) {
  return JSON.parse(localStorage.getItem(key));
}