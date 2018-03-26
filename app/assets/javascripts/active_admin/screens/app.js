//= require_self
//= require_tree ./components
//= require_tree ./services
//= require_tree ./controllers
//= require ./../../screens/components
//= require_tree ./../../screens/resources
//= require_tree ./../../screens/services

var app = angular.module("app", ['slick', 'ngResource', 'gridster', "ui.sortable", "checklist-model", "ngDialog", "ngMaterial"])

app.run(['$http', function($http){
  $http.defaults.headers.common.Authorization = 'Bearer 39a4680f9f6aee65cc94b49d5e81fc866e2fe15a6fd04af79eac9cdf99d035a3';
}])