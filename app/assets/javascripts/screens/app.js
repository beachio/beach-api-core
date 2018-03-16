//= require_self
//= require_tree ./components
//= require_tree ./config
//= require_tree ./controllers
//= require_tree ./resources
//= require_tree ./services

var app = angular.module("app", ['slick', 'gridster', 'checklist-model', 'ngResource', 'ngMaterial', 'ui.router'])

app.run(['Action', '$rootScope', function(Action, $rootScope){
  $rootScope.Action = Action;
}])