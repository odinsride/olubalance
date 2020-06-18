import { Controller } from "stimulus"
import * as bulmaToast from 'bulma-toast'

export default class extends Controller {

  static targets = [ "modal" ]

  connect () {
    //Invoke bulma toast notifications, if any
    //this.element.remove() TODO: is this needed?
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

  toggleModal (e) {
    // console.log(e.currentTarget.dataset.id)
    let modalId = e.currentTarget.dataset.id
    document.getElementById(modalId).classList.toggle('is-active')
  }
}
