class BeachChat {
  constructor (params) {
    this.flow_id = params.flow_id
    this.application_uid = params.application_uid
    this.id = "beach_chat_"+this.__guid__()
    this.class = 'beach-chat'
    this.containerStyle = 'position: fixed; display: none; right: 15px; bottom: 15px; width: 390px; max-height: calc(100% - 150px); height: 100%; box-shadow: 0 0 5px rgba(0,0,0,.15);'
    this.headerStyle = 'position: absolute; top: -40px; left: 0; right: 0; background: #3e70ff;border-radius: 10px 10px 0 0;padding: 10px;color: white;font-family: sans-serif;'
    this.iframeStyle = 'width: 100%; height: 100%; border: none;'
  }

  build () {
    var markup = ['<div id="'+this.id+'" style="'+this.containerStyle+'" class="'+this.class+'">',
      '<div style="'+this.headerStyle+'">Beach Chat</div>',
      "<iframe style='"+this.iframeStyle+"' src='http://localhost:3000/screens/view?flow_id="+this.flow_id+"&application_uid="+this.application_uid+"'></iframe>",
    '</div>']
    return markup.join("")
  }

  init() {
    document.body.innerHTML += this.build()
    this.container = document.getElementById(this.id)
    this.iframe = this.container.querySelector("iframe")


    this.iframe.addEventListener("load", () => {

      this.appLayout = this.iframe.contentWindow.document.querySelector(".app-layout")
      setTimeout(() => {
        this.container.style.display = "block"
        setInterval(() => {
          this.container.style.height = this.appLayout.scrollHeight + "px"
          // this.iframe.style.height = this.appLayout.scrollHeight + "px"
        }, 100)
      }, 1000)
    })

  }

  __guid__ () {
    function s4() {
      return Math.floor((1 + Math.random()) * 0x10000)
        .toString(16)
        .substring(1);
    }
    return s4() + s4();
  }
}