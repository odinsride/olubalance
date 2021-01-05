import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ 'submit', 'attachment', 'newreceipt', 'filename' ]

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

  // When an attachment file is selected, set the file-name field
  attachmentSelected() {
    var filename = this.attachmentTarget.value;
    var lastIndex = filename.lastIndexOf("\\");
    if (lastIndex >= 0) {
      filename = filename.substring(lastIndex + 1);
      filename = filename;
    }
    this.newreceiptTarget.innerHTML = "Adding receipt: ";
    this.filenameTarget.innerHTML = filename;
  }
}