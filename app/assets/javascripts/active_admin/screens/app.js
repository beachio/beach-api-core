//= require_self
//= require_tree ./components
//= require_tree ./services
//= require_tree ./controllers

var app = angular.module("app", ['slick', 'ngResource', 'gridster', "ui.sortable", "checklist-model", "ngDialog", "ngMaterial"])

app.run(['$http', 'Template', function($http, Template){
  Template.loaded = true;
  window.token = '4f626a6d50777a1e05b5e6763cd244b25bcc3b37ab47cd4265e9cbe950379b3e';
  $http.defaults.headers.common.Authorization = 'Bearer ' + window.token;
}])