import { Controller } from '@hotwired/stimulus';
import { DirectUpload } from '@rails/activestorage';

// Handles the import file field: on selection it uploads the (potentially
// multi-GB) ZIP straight to storage via ActiveStorage Direct Upload, showing a
// live progress bar. When the upload finishes it writes the returned signed_id
// into the hidden `archive` field and enables the confirm/submit trigger — so
// submitting the form (and reprocessing later) never re-uploads the bytes.
export default class extends Controller {
  static targets = [
    'input',
    'name',
    'trigger',
    'signedId',
    'progressWrap',
    'progress',
    'percent',
  ];
  static values = { url: String };

  selected() {
    const file = this.inputTarget.files[0];

    if (!file) {
      this.reset();
      return;
    }

    this.nameTarget.textContent = file.name;
    this.startUpload(file);
  }

  startUpload(file) {
    this.triggerTarget.disabled = true;
    this.showProgress(0);

    const upload = new DirectUpload(file, this.urlValue, this);
    upload.create((error, blob) => {
      if (error) {
        this.nameTarget.textContent = `Upload failed: ${error}`;
        this.hideProgress();
        return;
      }

      this.signedIdTarget.value = blob.signed_id;
      this.setPercent(100);
      this.triggerTarget.disabled = false;
    });
  }

  // Called by DirectUpload before it sends the file — hook the XHR's upload
  // progress events to drive the bar.
  directUploadWillStoreFileWithXHR(xhr) {
    xhr.upload.addEventListener('progress', (event) => {
      if (event.lengthComputable) {
        this.setPercent(Math.round((event.loaded / event.total) * 100));
      }
    });
  }

  showProgress(pct) {
    this.progressWrapTarget.classList.remove('is-hidden');
    this.setPercent(pct);
  }

  hideProgress() {
    this.progressWrapTarget.classList.add('is-hidden');
  }

  setPercent(pct) {
    if (this.hasProgressTarget) this.progressTarget.value = pct;
    if (this.hasPercentTarget) this.percentTarget.textContent = `${pct}%`;
  }

  reset() {
    this.nameTarget.textContent = 'No file selected';
    this.signedIdTarget.value = '';
    this.triggerTarget.disabled = true;
    this.hideProgress();
  }
}
