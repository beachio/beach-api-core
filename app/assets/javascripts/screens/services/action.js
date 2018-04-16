app.service('Action', ['$state', 'Screen', 'Model', 'ngDialog', '$http', 'SocialNetwork', function($state, Screen, Model, ngDialog, $http, SocialNetwork){
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
      $http.post('/v1/endpoints', _.extend({data: Model.data}, payload))
        .then(function (res) {
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
    OPEN_IFRAME: function (payload) {
      ngDialog.open({
        template: "<iframe id='open_iframe' src='"+payload.url+"'></iframe>",
        plain: true,
        className: 'ngdialog-mobile-modal',
        controller: ['$scope', '$interval', '$timeout', function (scope, $interval, $timeout) {
          $timeout(function () {
            $("#open_iframe").load(function () {
              if ($('#open_iframe')[0].contentWindow.$('iframe').length) scope.withIframe = true;

              scope.interval = $interval(function () {
                if (scope.withIframe && $('#open_iframe')[0].contentWindow.$('iframe').length === 0) {
                  scope.closeThisDialog();
                  scope.interval.cancel();
                }
              },300)
              scope.$apply();
            })
          }, 100)
        }],
      })
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
    }
  }
}])
