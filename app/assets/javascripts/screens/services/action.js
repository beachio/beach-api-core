app.service('Action', ['$state', 'Screen', 'Model', 'ngDialog', function($state, Screen, Model, ngDialog){
  var Action = this;


  Action.call = function (action) {
    Action.list[action.type](action.payload)
  }

  Action.list = {
    NEXT_SCREEN: function () {
      Action.animation_class = 'slide-left'

      Screen.next({id: $state.params.id}, function (res) {
        if (res)
          $state.go('screen_path', {id: res.id})
      })
    },
    PREV_SCREEN: function () {
      Action.animation_class = 'slide-right'

      Screen.prev({id: $state.params.id}, function (res) {
        if (res)
          $state.go('screen_path', {id: res.id})
      })
      
    },
    GO_TO_SCREEN_BY_ID: function (payload) {
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
    SUBMIT_ON_SERVER: function () {
      Action.animation_class = 'slide-down'
      $state.go('results_path')
    },
    OPEN_MODAL: function (payload) {
      ngDialog.open({
        template: 'mobile-modal.html',
        className: 'ngdialog-mobile-modal',
        controller: ['$scope', function (scope) {
          $('.app-layout').css({filter: "blur(10px)"})
          scope.settings = payload
        }],
        preCloseCallback: function (value) {
          $('.app-layout').css({filter: "none"})
        }
      })
    }
  }
}])