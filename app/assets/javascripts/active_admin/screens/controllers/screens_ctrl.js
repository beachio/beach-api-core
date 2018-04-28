app.controller('ScreensCtrl', ['ngDialog', '$scope', '$timeout', '$http', function(ngDialog, $scope, $timeout, $http){
  var ctrl = this;

  var flow_id = window.location.pathname.match(/flows\/(.+)\/edit/)[1]
  $http.get("/admin/flows/"+flow_id+"/screens")
       .then(function (res) {
          ctrl.screens = res.data;
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
}])