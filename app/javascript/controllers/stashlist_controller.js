import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "list", "chevron" ]
  
  initialize() {
    this.stashHidden = JSON.parse(localStorage.getItem('stashHidden')) // must use JSON.parse to convert string to Boolean
    
    if (this.stashHidden === null)
      this.stashHidden = true

    this.toggleList()
  }

  toggle(e) {
    e.preventDefault()
    this.stashHidden = !this.stashHidden
    localStorage.setItem('stashHidden', JSON.stringify(this.stashHidden))
    this.toggleList()
  }

  toggleList() {
    if (this.stashHidden)
      this.hide()
    else
      this.show()
  }

  hide() {
    this.chevronTarget.classList.add('fa-chevron-right')
    this.listTarget.classList.add('is-hidden')
  }

  show() {
    this.chevronTarget.classList.add('fa-chevron-down')
    this.listTarget.classList.remove('is-hidden')
  }
}