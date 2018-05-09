app.service('Template', ['User', 'DataSource', '$interval', 'Model', function(User, DataSource, $interval, Model){
  var Template = this;

  Template.reloadTemplate = function (callback) {
    User.get(function (res) {
      Template.User = res
      Template.loaded = true
    })
    Template.Model = Model.data
    Template.DataSource = DataSource
  }

  Template.updateDate = function () {
    var date = new Date()
    Template.date = date.getDate()
    Template.hours = date.getHours()
    Template.minutes = date.getMinutes()
    Template.seconds = date.getSeconds()

    var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    Template.month = months[date.getMonth()]

    var dayOfWeek = {1: 'Monday',2: 'Tuesday',3: 'Wednesday',4: 'Thursday',5: 'Friday',6: 'Saturday',7: 'Sunday'}
    Template.dayOfWeek = dayOfWeek[date.getDay()]
  }

  $interval(function () {
    Template.updateDate()
  }, 100)


}])