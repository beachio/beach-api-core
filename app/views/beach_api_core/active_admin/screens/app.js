var app = angular.module("app", ["ui.sortable", "checklist-model", "ngDialog"])

app.controller('ScreensCtrl', ['ngDialog', function(ngDialog){
  var ctrl = this;

  ctrl.openSettingsWindow = function (screen) {
    ngDialog.open({
      template: '<h2>Screen settings</h2>'
                + '<label class="label">'
                  + '<input type="checkbox" ng-model="screen.rotator"> Rotator'
                + '</label>'
                + '<br>'
                + '<label ng-show="screen.rotator" class="label">'
                  + 'Rotation Delay, ms:&nbsp;'
                  + '<input class="form-control" type="text" ng-model="screen.rotation_delay">'
                + '</label>'
                + '<hr>'
                + '<div class="text-right"><button ng-click="closeThisDialog()">Save</button></div>'
                + '',
      plain: true,
      controller: ['$scope', function (scope) {
        scope.screen = screen
      }]
    })
  }
}])