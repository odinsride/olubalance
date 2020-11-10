import { Controller } from "stimulus"
import * as bulmaToast from 'bulma-toast'

export default class extends Controller {

  static targets = [ "modal", "dropDown", "dropDownButton" ]

  connect () {
    //Invoke bulma toast notifications, if any
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

  /**
   * toggleModal
   * @param {*} e - Event
   * Toggle the is-active class to hide and show a modal for the given passed in data-id
   */
  toggleModal (e) {
    // console.log(e.currentTarget.dataset.id)
    let modalId = e.currentTarget.dataset.id
    document.getElementById(modalId).classList.toggle('is-active')
  }

  /**
   * toggleDropdown
   * Toggle the is-active class to hide and show a dropdown
   */
  toggleDropdown () {
    event.preventDefault();
    var ariaExpanded = this.dropDownButtonTarget.getAttribute('aria-expanded') == 'true';
    this.dropDownButtonTarget.setAttribute('aria-expanded', !ariaExpanded)
    this.dropDownTarget.classList.toggle('is-active')
  }
}
