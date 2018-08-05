app.service('Message', [function(){
  var Message = this;

  Message.list = [{from: "bot", template: "Hello!"}, {from: "user", template: "Hi!"}]
}])