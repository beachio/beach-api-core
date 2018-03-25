//= require_self
//= require_tree ./components
//= require_tree ./services
//= require_tree ./controllers
//= require ./../../screens/components
//= require_tree ./../../screens/resources
//= require_tree ./../../screens/services

var app = angular.module("app", ['slick', 'ngResource', 'gridster', "ui.sortable", "checklist-model", "ngDialog", "ngMaterial"])