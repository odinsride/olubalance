import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="trxsearch"
export default class extends Controller {
  static targets = ['description'];

  clear(event) {
    event.preventDefault();
    this.descriptionTarget.value = '';
    this.element.requestSubmit();
  }

  submit() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.element.requestSubmit();
    }, 250);
  }
}
