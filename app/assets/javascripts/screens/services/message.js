app.service('Message', ['$timeout', function($timeout){
  var Message = this;

  Message.list = []

  Message.push = (message) => {
    if (message.from == 'bot') {
      Message.addToTempList(message)
    } else {
      Message.list.push(message)
    }
  }

  Message.tempList = []
  Message.addToTempList = (message) => {
    Message.tempList.push(message)
    Message.extractFromTempList()
  }

  Message.extractFromTempList = () => {
    if (Message.tempList.length && !Message.inProgress) {
      Message.inProgress = true
      $timeout(() => {
          Message.list.push(Message.tempList.shift())
          if (!Message.tempList.length) Message.inProgress = false
          Message.extractFromTempList()
      }, 1000)
    } else {
      Message.inProgress = false
    }
  }
}])