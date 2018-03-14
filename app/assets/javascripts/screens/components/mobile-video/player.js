app.service('Player', ['$http', function($http){
  var Player = this,
      youtubeRegexp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/,
      vimeoRegexp = /^.*?(vimeo\.com\/|player\.vimeo\.com)/

  Player.matchYoutube = function (url) {
    return url.match(youtubeRegexp)
  }

  Player.getYoutubeId = function (url) {
    var match = Player.matchYoutube(url)
    return match ? match[7] : false
  }

  Player.getYoutubeUrl = function (url) {
    return 'https://www.youtube.com/embed/' + Player.getYoutubeId(url)
  }

  Player.youtubePreview = function (url) {
    return 'https://img.youtube.com/vi/'+Player.getYoutubeId(url)+'/maxresdefault.jpg'
  }



  Player.matchVimeo = function (url) {
    return url.match(vimeoRegexp)
  }

  Player.getVimeoId = function (url) {
    var r = /(videos|video|channels|\.com)\/([\d]+)/;
    return url.match(r)[2];
  }

  Player.getVimeoUrl = function (url) {
    return 'https://player.vimeo.com/video/' + Player.getVimeoId(url) + '?autoplay=1'
  }

  Player.vimeoPreview = function (url) {
    return $http.get('https://vimeo.com/api/oembed.json?url='+url)
  }
}])