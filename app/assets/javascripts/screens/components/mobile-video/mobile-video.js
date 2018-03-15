app.directive('mobileVideo', ["Model", "Player", function(Model, Player){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      settings: "="
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    require: '^screen',
    templateUrl: 'mobile-video.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.screen = controller.screen;
      $scope.$watch('[settings.url, settings.preview.url]', function () {
        var url = $scope.settings.url

        if (Player.matchYoutube(url)) {
          $scope.type = "youtube"
          $scope.url = Player.getYoutubeUrl(url)
          $scope.preview = $scope.settings.preview && $scope.settings.preview.url ? $scope.settings.preview.url : Player.youtubePreview(url)
        } else if (Player.matchVimeo(url)) {
          $scope.type = "vimeo"
          $scope.url = Player.getVimeoUrl(url)

          Player.vimeoPreview(url).then(function (res) {
            $scope.preview = $scope.settings.preview && $scope.settings.preview.url ? $scope.settings.preview.url : res.data.thumbnail_url
          })
        }
      })
    }
  }
}])

app.config(['$sceDelegateProvider', function($sceDelegateProvider) {
  $sceDelegateProvider.resourceUrlWhitelist(['**']);
}]);