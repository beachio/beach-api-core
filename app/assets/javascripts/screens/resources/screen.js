app.factory('Screen', ['$resource', 'Config', 'Message', 'ComponentState', function($resource, Config, Message, ComponentState){

  var Screen = $resource('/v1/screens/:id', {"id":"@id", bot_uuid: Config.bot_uuid}, {
    "next": {
      "method": "GET",
      "url": "/v1/screens/:id/next",
    },
    "prev": {
      "method": "GET",
      "url": "/v1/screens/:id/prev",
    },
    "flow": {
      "method": "GET",
      "url": "/v1/screens/flow",
    },
    "bot": {
      "method": "GET",
      "url": "/v1/screens/bot",
    },
    "main_flow": {
      "method": "GET",
      "url": "/v1/screens/main_flow",
    },
  })

  Screen.list = []
  Screen.active = null

  Screen.push = (screen) => {
    if (screen && screen.id) {
      Screen.list.push(screen)
      Screen.active = screen

      if (screen.content.header.descriptionsType == "states") {
        var states = screen.content.header.states;
        var activeState = ComponentState.activeState(states);
        Message.push({template: activeState.description, from: 'bot', components: screen.content.body})
      } else {
        var header = _.sample(screen.content.header.descriptions)
        if (header) {
          Message.push({template: header.text, from: 'bot', components: screen.content.body})
        } else {
          Message.push({template: "", from: 'bot', components: screen.content.body})
        }
      }
    }
  }

  return Screen
}])