//= require_self
//= require_tree ./components
//= require_tree ./config
//= require_tree ./controllers
//= require_tree ./resources
//= require_tree ./services

var app = angular.module("app", ['slick', 'ngDialog', 'gridster', 'checklist-model', 'ngResource', 'ngMaterial', 'ui.router'])

app.run(['Action', '$rootScope', '$http', function(Action, $rootScope, $http){
  $rootScope.Action = Action;
  $http.defaults.headers.common.Authorization = 'Bearer 39a4680f9f6aee65cc94b49d5e81fc866e2fe15a6fd04af79eac9cdf99d035a3';
}])