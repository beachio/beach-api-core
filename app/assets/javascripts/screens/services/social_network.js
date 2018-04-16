app.service('SocialNetwork', [function(){
  var SocialNetwork = this;

  SocialNetwork.facebook = {
    follow: function () {
      window.open("https://m.facebook.com/groups/247692329108499", "myWindow", "width=600,height=400")
    },
    share: function (params) {
      FB.ui({
            method: 'share',
            display: 'popup',
            href: params.url,
          }, function(response){
            console.log(response)
          });
    }
  }

  SocialNetwork.twitter = {
    follow: function () {
      window.open("https://twitter.com/mixfit_dev", "myWindow", "width=600,height=400")
    },
    share: function () {
      alert("Share Twitter Mock")
    },
    retweet: function () {
      alert("Retweet Twitter Mock")
      // body...
    }
  }

  SocialNetwork.instagram = {
    follow: function () {
      alert("Follow Instagram Mock")
      // body...
    },
    like: function () {
      alert("Like Instagram Mock")
      // body...
    }
  }
}])


window.fbAsyncInit = function() {
  FB.init({
    appId            : '2046230098924690',
    autoLogAppEvents : true,
    xfbml            : true,
    version          : 'v2.12'
  });
};

(function(d, s, id){
   var js, fjs = d.getElementsByTagName(s)[0];
   if (d.getElementById(id)) {return;}
   js = d.createElement(s); js.id = id;
   js.src = "https://connect.facebook.net/en_US/sdk.js";
   fjs.parentNode.insertBefore(js, fjs);
 }(document, 'script', 'facebook-jssdk'));