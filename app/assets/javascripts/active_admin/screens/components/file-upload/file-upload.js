app.directive('fileUpload', ['$http', '$timeout', function ($http, $timeout) {
    return {
      scope: {
        fileUpload: "=",
        ngModel: "=",
        hash: "=",
        percentCompleted: "=",
        maxSize: "="
      },
      restrict: 'A',
      link: function($scope, element, attrs) {
        $scope.percentCompleted = undefined;

        element.bind('change', function(){
          if ($scope.xhr) $scope.xhr.abort();

          $scope.percentCompleted = 0;
          $scope.xhr = new XMLHttpRequest;

          var fd = new FormData(),
              file = element[0].files[0];

          if ($scope.maxSize && file.size/1024/1024 > $scope.maxSize) {
            return alert("File size is more then " + $scope.maxSize + " Mb")
          }
          
          fd.append("attachments[]", file);

          
          $scope.xhr.upload.onprogress = function(e) {
              $scope.$apply(function() {
                  if (e.lengthComputable) {
                      $scope.percentCompleted = Math.round(e.loaded / e.total * 100);
                  }
              });
          };

          $scope.xhr.onload = function() {
            var res = JSON.parse(this.responseText)
            
            if (this.status == 200) {
              $scope.$apply(function() {
                $scope.ngModel = res;
                $scope.percentCompleted = undefined;
              });
            } else {
              alert(res.msg || "Uploading error")
            }
          };


          $scope.xhr.open('POST', $scope.fileUpload);
          $scope.xhr.send(fd);

          element[0].value = '';
        })
      }
    }
  }])