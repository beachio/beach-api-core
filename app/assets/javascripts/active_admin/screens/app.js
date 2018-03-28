//= require_self
//= require_tree ./components
//= require_tree ./services
//= require_tree ./controllers

var app = angular.module("app", ['slick', 'ngResource', 'gridster', "ui.sortable", "checklist-model", "ngDialog", "ngMaterial"])

app.run(['$http', 'Template', function($http, Template){
  $http.defaults.headers.common.Authorization = 'Bearer 6552bb812ffff1a3e13d858b4065be49aee48f8013245003339567400c1510bd';
  Template.loaded = true;
}])