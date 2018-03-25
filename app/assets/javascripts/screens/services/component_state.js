app.service('ComponentState', ['Template', '$parse', function(Template, $parse){
  var ComponentState = this;

  ComponentState.activeStates = function (states) {
    return _.select(states, function (state) {
      return !state.condition || $parse(state.condition)(Template)
    })
  }
}])