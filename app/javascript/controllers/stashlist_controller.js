import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['list', 'chevron'];

  initialize() {
    this.stashHidden = this.getStashVisibility(); // Retrieve visibility state from sessionStorage
    this.updateVisibility(); // Update the visibility on initialization
  }

  toggle(event) {
    event.preventDefault(); // Prevent default anchor click behavior
    this.stashHidden = !this.stashHidden; // Toggle visibility state
    this.updateVisibility(); // Update the visibility of the stash list
    this.setStashVisibility(this.stashHidden); // Save the visibility state to sessionStorage
  }

  updateVisibility() {
    if (this.stashHidden) {
      this.hide(); // Hide the stash list
    } else {
      this.show(); // Show the stash list
    }
  }

  hide() {
    this.chevronTarget.classList.remove('fa-chevron-down');
    this.chevronTarget.classList.add('fa-chevron-right');
    this.listTarget.classList.add('is-hidden'); // Use your CSS class for hidden
  }

  show() {
    this.chevronTarget.classList.remove('fa-chevron-right');
    this.chevronTarget.classList.add('fa-chevron-down');
    this.listTarget.classList.remove('is-hidden'); // Show the stash list
  }

  // Helper methods to get and set stash visibility in sessionStorage
  getStashVisibility() {
    const stashHidden = sessionStorage.getItem('stashHidden');
    return stashHidden !== null ? JSON.parse(stashHidden) : true; // Default to true if not set
  }

  setStashVisibility(value) {
    sessionStorage.setItem('stashHidden', JSON.stringify(value)); // Save the visibility state
  }
}
