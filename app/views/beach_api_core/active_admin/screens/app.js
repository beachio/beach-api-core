var app = angular.module("app", ["ui.sortable", "checklist-model", "ngDialog"])

app.controller('ScreensCtrl', ['ngDialog', '$scope', function(ngDialog, $scope){
  var ctrl = this;

  $scope.$watch('ctrl.screens', function (screens) {
    ctrl.textScreens = JSON.stringify(screens)
  }, true)
}])