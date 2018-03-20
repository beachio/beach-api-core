app.directive("contenteditable", function() {
  return {
    restrict: "A",
    scope: {
      ngModel: "="
    },
    link: function($scope, element, attrs, ngModel) {
      element.bind("blur keyup change", function() {
        $scope.ngModel = element.html();
        $scope.$apply();
      }).on('paste', function (e) {
        console.log("paste")
          e.preventDefault();
          var contentOnBlur = (e.originalEvent || e).clipboardData.getData('text/plain') || prompt('Paste something..');
          contentOnBlur = contentOnBlur.replace(/(<([^>]+)>)/ig,'');
          document.execCommand('insertText', false, contentOnBlur);
          $scope.ngModel = element.html();
          $scope.$apply();
      })
    }
  };
});