import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "menu", "burger" ]

  toggleNav() {
    var ariaExpanded = this.burgerTarget.getAttribute('aria-expanded').value == 'true'
    this.burgerTarget.setAttribute('aria-expanded', (!ariaExpanded).toString()) 
    this.burgerTarget.classList.toggle('is-active')
    this.menuTarget.classList.toggle('is-active')
  }
}
