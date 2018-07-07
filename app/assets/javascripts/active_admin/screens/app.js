//= require_self
//= require json-print
//= require_tree ./components
//= require_tree ./services
//= require_tree ./controllers

var app = angular.module("app", ['slick', 'json-print', 'ngResource', 'gridster', "ui.sortable", "checklist-model", "ngDialog", "ngMaterial"])

app.run(['$http', 'Template', function($http, Template){
  Template.loaded = true;
  window.token = '0e04cd8452b3cb4a5208d4698ac5448f05f26c7dfbb74c2745546d9ccd7a578b';
  $http.defaults.headers.common.Authorization = 'Bearer ' + window.token;
}])