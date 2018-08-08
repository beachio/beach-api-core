app.service('Action', ['Screen', 'Model', 'ngDialog', '$http', 'SocialNetwork', 'DataSource', 'Message', function(Screen, Model, ngDialog, $http, SocialNetwork, DataSource, Message){
  var Action = this;

  Action.call = function (action) {
    Action.list[action.type](action.payload)
  }

  Action.list = {
    NEXT_SCREEN: function () {
      Screen.next({id: Screen.active.id}, function (res) {
        Screen.push(res)
      })
    },
    PREV_SCREEN: function () {
      Screen.prev({id: Screen.active.id}, function (res) {
        Screen.push(res)
      })
    },
    GO_TO_SCREEN_BY_ID: function (payload) {
      Screen.prev({id: payload.screen_id}, function (res) {
        Screen.push(res)
      })
    },
    OPEN_FLOW: function (payload) {
      if (payload.flow_id) {
        Screen.flow(payload, function (res) {
          Screen.push(res)
        })
      }
    },
    PUSH_MESSAGE: function (payload) {
      Message.push(angular.copy(payload.data))

      if (payload.after_push_message_action) Action.call(payload.after_push_message_action)
    },
    EXIT: function () {
      Action.animation_class = 'slide-down'
      Screen.main_flow(function (res) {
        Model = {}
        Screen.push(res)
      })
    },
    SUBMIT_ON_SERVER: function (payload) {
      payload.data = payload.data || {}
      _.extend(payload.data, Model);
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
    OPEN_CAMERA: uploadImage,
    OPEN_GALLERY: uploadImage,
  }

  function uploadImage(payload) {
    openFileDialog(function (file) {
      if (payload.after_action){
        if (payload.dataSource) {
          DataSource[payload.dataSource] = file.url;
        }
        payload.after_action.payload = payload.after_action.payload || {}
        payload.after_action.payload.data = payload.after_action.payload.data || {}
        payload.after_action.payload.data.url = file.url
        Action.call(payload.after_action);
      }
    })
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
