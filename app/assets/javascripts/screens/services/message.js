app.service('Message', [function(){
  var Message = this;

  Message.list = []

  Message.push = (message) => {
    Message.list.push(message)
  }
}])