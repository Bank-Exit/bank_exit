import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.storageKey = "hide-merchants-filters";

    this.element.addEventListener(
      "toggle",
      this.#toggleSearchForm.bind(this),
      false,
    );

    if (this.storageKey in localStorage) {
      if (this.element.hasAttribute("open")) {
        this.element.removeAttribute("open");
      }
    }
  }

  disconnect() {
    this.element.removeEventListener(
      "toggle",
      this.#toggleSearchForm.bind(this),
      false,
    );
  }

  #toggleSearchForm() {
    if (this.element.open) {
      localStorage.removeItem(this.storageKey);
    } else {
      localStorage.setItem(this.storageKey, true);
    }
  }
}
