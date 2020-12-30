import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ 'submit', 'attachment' ]

  create() {
    this.submitTarget.classList.add('is-loading')
    if (this.attachmentTarget.value != '') {
      this.attachmentTarget.parentNode.classList.add('is-hidden')
      this.submitTarget.parentNode.insertAdjacentHTML('afterend', `
        <div class="control" style="display: flex; align-items: center">
          Uploading attachment ...
        </div>
      `)
    }
  }
}