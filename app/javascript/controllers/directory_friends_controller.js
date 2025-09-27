import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.storageKey = "hide-directory-friends";

    this.element.addEventListener("toggle", this.#toggle.bind(this), false);

    if (this.storageKey in localStorage) {
      if (this.element.hasAttribute("open")) {
        this.element.removeAttribute("open");
      }
    }
  }

  disconnect() {
    this.element.removeEventListener("toggle", this.#toggle.bind(this), false);
  }

  #toggle() {
    if (this.element.open) {
      localStorage.removeItem(this.storageKey);
    } else {
      localStorage.setItem(this.storageKey, true);
    }
  }
}
