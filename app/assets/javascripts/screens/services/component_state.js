app.service('ComponentState', ['Template', '$parse', '$rootScope', function(Template, $parse, $rootScope){
  var ComponentState = this;

  ComponentState.activeState = function (states) {
    return _.last(ComponentState.activeStates(states))
  }

  ComponentState.activeStates = function (states) {
    var template = _.extend({
      states: states
    }, Template)

    return _.select(states, function (state) {
      return !state.condition || $parse(state.condition)(template)
    })
  }

}])