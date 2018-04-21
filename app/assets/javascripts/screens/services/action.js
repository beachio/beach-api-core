app.service('Action', ['$state', 'Screen', 'Model', 'ngDialog', '$http', 'SocialNetwork', 'DataSource', function($state, Screen, Model, ngDialog, $http, SocialNetwork, DataSource){
  var Action = this;


  Action.call = function (action) {
    Action.list[action.type](action.payload)
  }

  Action.list = {
    NEXT_SCREEN: function () {
      if ($state.params) {
        Action.animation_class = 'slide-left'

        Screen.next({id: $state.params.id}, function (res) {
          if (res)
            $state.go('screen_path', {id: res.id})
        })
      }
    },
    PREV_SCREEN: function () {
      if ($state.params) {
        Action.animation_class = 'slide-right'

        Screen.prev({id: $state.params.id}, function (res) {
          if (res)
            $state.go('screen_path', {id: res.id})
        })
      }

    },
    GO_TO_SCREEN_BY_ID: function (payload) {
      Action.animation_class = 'slide-fade'
      $state.go('screen_path', {id: payload.screen_id})
    },
    OPEN_FLOW: function (payload) {
      Action.animation_class = 'slide-fade'
      Screen.flow(payload, function (res) {
        $state.go('screen_path', {id: res.id})
      })
    },
    EXIT: function () {
      Action.animation_class = 'slide-down'
      Screen.main_flow(function (res) {
        Model.data = {}
        $state.go('screen_path', {id: res.id})
      })
    },
    SUBMIT_ON_SERVER: function (payload) {
      console.log(payload)
      payload.data = payload.data || {}
      _.extend(payload.data, Model.data);
      $http.post('/v1/endpoints', payload)
        .then(function (res) {
          if (payload.dataSource) {
            DataSource[payload.dataSource] = res.data;
          }

          if (payload.after_submit_action){
            Action.call(payload.after_submit_action);
          }
          if (res.data.action) {
            Action.call(res.data.action)
          }
        })
    },
    OPEN_MODAL: function (payload) {
      ngDialog.open({
        template: 'mobile-modal.html',
        className: 'ngdialog-mobile-modal',
        controller: ['$scope', function (scope) {
          $('.app-layout').css({filter: "blur(10px)"})
          scope.settings = payload;
          scope.Action = Action;
        }],
        preCloseCallback: function (value) {
          $('.app-layout').css({filter: "none"})
        }
      })
    },
    OPEN_WEBVIEW: function (payload) {
      window.open(payload.url, "myWindow", "width=375,height=680")
    },
    OPEN_MENU: function (payload) {
      ngDialog.open({
        template: 'mobile-menu.html',
        className: 'ngdialog-mobile-menu',
        controller: ['$scope', function (scope) {
          $('.app-layout').css({filter: "blur(10px)"})
          scope.settings = payload

          scope.openFlow = function (flow_id) {
            Action.list["OPEN_FLOW"]({flow_id: flow_id})
            scope.closeThisDialog()
          }
        }],
        preCloseCallback: function (value) {
          $('.app-layout').css({filter: "none"})
        }
      })
    },
    SOCIAL_NETWORKS_ACTION: function (payload) {
      SocialNetwork[payload.socialNetwork.name][payload.socialNetwork.action](payload.socialNetwork.params)
    },
    OPEN_CAMERA: function (payload) {
      openFileDialog(function (file) {
        if (payload.after_action){
          payload.after_action.payload = payload.after_action.payload || {}
          payload.after_action.payload.data = payload.after_action.payload.data || {}
          payload.after_action.payload.data.url = file.url
          Action.call(payload.after_action);
        }
      })
    },
    OPEN_GALLERY: function (payload) {
      openFileDialog(function (file) {
        if (payload.after_action){
          payload.after_action.payload = payload.after_action.payload || {}
          payload.after_action.payload.data = payload.after_action.payload.data || {}
          payload.after_action.payload.data.url = file.url
          Action.call(payload.after_action);
        }
      })
    }
  }

  function openFileDialog(callback) {
    var input = document.createElement('input');
    input.type = 'file';
    input.click();

    input.onchange = function (e) {
      var fd = new FormData();
      fd.append("attachment", input.files[0]);
      
      var xhr = new XMLHttpRequest,
          percentCompleted = 0;

      xhr.upload.onprogress = function(e) {
          percentCompleted = Math.round(e.loaded / e.total * 100);
      }

      xhr.onload = function() {
        var res = JSON.parse(this.responseText)
        
        if (this.status == 200) {
          callback(res)
        } else {
          alert("Uploading error")
        }
      }
      xhr.open('POST', '/v1/uploads');
      xhr.setRequestHeader("Authorization", 'Bearer ' + window.token)
      xhr.send(fd);
    }
  }
}])
