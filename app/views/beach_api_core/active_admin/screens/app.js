var app = angular.module("app", ["ui.sortable", "checklist-model", "ngDialog"])

app.controller('ScreensCtrl', ['ngDialog', '$scope', function(ngDialog, $scope){
  var ctrl = this;

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