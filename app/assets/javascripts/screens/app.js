var app = angular.module("app", ['checklist-model', 'ngResource', 'ngMaterial', 'ui.router'])

app.run(['Action', '$rootScope', function(Action, $rootScope){
  $rootScope.Action = Action;
}])