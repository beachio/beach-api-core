app.controller('ScreensCtrl', ['ngDialog', '$scope', '$timeout', '$http', '$timeout', function(ngDialog, $scope, $timeout, $http, $timeout){
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
  $scope.versions = []
  $http.get("/admin/flows/10/versions")
       .then(function (res) {
         $scope.versions = res.data;
       })

  ctrl.openCommit = function () {
    ctrl.commit = prompt("What did you do?");
    if (!ctrl.commit) return ctrl.openCommit();
    $timeout(function () {
      document.getElementById("edit_flow").submit();
    })
  }
  ctrl.openVersions = function () {
    ngDialog.open({
        template: 'versions/versions_modal.html',
        className: 'ngdialog-settings',
        controller: ['$scope', '$http', function (scope, $http) {
          scope.versions = $scope.versions
          scope.activeVersion = $scope.activeVersion
          scope.setVersion = function (version) {
            $scope.activeVersion = version;
            ctrl.screens = version.screens;
            console.log(scope.activeVersion)
            scope.closeThisDialog()
          }
        }]
      })
  }
}])