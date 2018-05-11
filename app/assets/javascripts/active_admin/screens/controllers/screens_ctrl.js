app.controller('ScreensCtrl', ['ngDialog', '$scope', '$timeout', '$http', function(ngDialog, $scope, $timeout, $http){
  var ctrl = this;

  var flow_id = window.location.pathname.match(/flows\/(.+)\/edit/)[1]
  $http.get("/admin/flows/"+flow_id+"/screens")
       .then(function (res) {
          ctrl.screens = res.data;
          ctrl.mainScreens = _.clone(res.data);
       })


  $scope.$watch('ctrl.screens', function (screens) {
    ctrl.textScreens = JSON.stringify(screens)
  }, true)

  $scope.$on('makeSubmit', function(event, data){
                if(data.formName === $attr.name) {
                  $timeout(function() {
                    $el.triggerHandler('submit'); //<<< This is Important

                    //equivalent with native event
                    //$el[0].dispatchEvent(new Event('submit')) 
                  }, 0, false);   
                }
              })


  ctrl.openVersions = function () {
    ngDialog.open({
        template: 'versions/versions_modal.html',
        className: 'ngdialog-settings',
        controller: ['$scope', '$http', function (scope, $http) {
          $http.get("/admin/flows/10/versions")
               .then(function (res) {
                 scope.versions = res.data;
               })

          scope.setVersion = function (version) {
            scope.activeVersion = version;
            ctrl.screens = version.screens;
            scope.closeThisDialog()
          }

          scope.setMainVersion = function () {
            ctrl.screens = ctrl.mainScreens;
            scope.activeVersion = undefined;
            scope.closeThisDialog()
          }
        }]
      })
  }
}])