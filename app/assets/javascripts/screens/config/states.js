app.config(['$httpProvider', '$locationProvider', '$stateProvider', function($httpProvider, $locationProvider, $stateProvider) {
    $httpProvider.defaults.paramSerializer = '$httpParamSerializerJQLike';
  }])
app.config(['$locationProvider', '$stateProvider', function ($locationProvider, $stateProvider) {
  /*
  *  Enable HTML5 History API
  */
  $locationProvider.html5Mode({enabled: true, requireBase: false});
  
  /*
  *  States
  */
  $stateProvider
    .state('screen_path', {
      url: '/screens/:id/view',
      templateUrl: 'app.html',
      controller: 'ScreensCtrl as ctrl',
    })
    .state('results_path', {
      url: '/screens/view',
      templateUrl: 'results.html',
      controller: 'ResultsCtrl as ctrl',
    })

}])

