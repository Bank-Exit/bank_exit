import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  dispatch(e) {
    e.preventDefault();

    const event = new CustomEvent(this.element.dataset.dispatchEvent, {
      bubbles: true,
    });

    window.dispatchEvent(event);
  }
}
