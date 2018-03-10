app.service('Action', ['$state', 'Screen', 'Model', function($state, Screen, Model){
  var Action = this;

  Action.call = function (action) {
    Action.list[action.type](action.payload)
  }

  Action.list = {
    NEXT_SCREEN: function () {
      Screen.next({id: $state.params.id}, function (res) {
        $state.go('screen_path', {id: res.id})
      })
    },
    PREV_SCREEN: function () {
      Screen.prev({id: $state.params.id}, function (res) {
        $state.go('screen_path', {id: res.id})
      })
    },
    GO_TO_SCREEN_BY_ID: function (payload) {
      $state.go('screen_path', {id: payload.screen_id})
    },
    EXIT: function () {
      $state.go('screen_path', {id: 0})
    },
    SUBMIT_ON_SERVER: function () {
      $state.go('results_path')
    }
  }
}])