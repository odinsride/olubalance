import { Controller } from "stimulus"
import * as bulmaToast from 'bulma-toast'

export default class extends Controller {

  connect () {
    //Invoke bulma toast notifications, if any
    //this.element.remove()
    var message = this.data.get("message")
    var messageType = this.data.get("message-type")
    if (message && messageType) {
      bulmaToast.toast({ 
        message: message,
        position: 'top-center',
        type: 'is-' + messageType,
        duration: 1500 
      })
    }
  }
}
