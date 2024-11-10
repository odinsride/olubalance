import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'accounttype', 'interestrate', 'creditlimit' ]

  connect() {
    this.toggleFields()
  }
  
  toggleFields() {
    if (this.accounttypeTarget.value == 'credit') {
      this.interestrateTarget.classList.remove('hidden')
      this.creditlimitTarget.classList.remove('hidden')
    }
    else if (this.accounttypeTarget.value == 'savings') {
      this.interestrateTarget.classList.remove('hidden')
      this.creditlimitTarget.classList.add('hidden')
    }
    else {
      this.interestrateTarget.classList.add('hidden')
      this.creditlimitTarget.classList.add('hidden')
    }
  }
}