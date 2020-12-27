import { Controller } from "stimulus"

export default class extends Controller {

  static targets = [ "menu", "button" ]

  /**
   * toggle
   * @param {*} e - Event
   * Toggle the is-active class to hide and show a dropdown
   */
  toggle (e) {
    e.stopPropagation()
    e.preventDefault()

    if (this.buttonTarget.getAttribute('aria-expanded') == "false") {
      this.show()
    } else {
      this.hide(e)
    }
  }
  
  /**
   * show
   * Add the is-active class to show a dropdown
   */
  show() {
    this.buttonTargets.forEach((b) => b.setAttribute('aria-expanded', "false"))
    this.menuTargets.forEach((m) => m.classList.remove('is-active'))
    this.buttonTarget.setAttribute('aria-expanded', "true")
    this.element.classList.add('is-active')
  }
  
  /**
   * hide
   * @param {*} e 
   * Remove the is-active class to hide a dropdown
   */
  hide(e) {
    if (e && (this.menuTarget.contains(e.target))) {
      e.preventDefault()
      return
    }
    this.buttonTarget.setAttribute('aria-expanded', "false")
    this.element.classList.remove('is-active')
  }
}
