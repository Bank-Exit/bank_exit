import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.storageKey = "hide-directory-friends";

    if (this.#shouldHideDirectoryFriends()) {
      this.element.removeAttribute("open");
    } else {
      this.element.setAttribute("open", "open");
    }
  }

  toggle() {
    if (this.element.open) {
      localStorage.setItem(this.storageKey, true);
    } else {
      localStorage.removeItem(this.storageKey);
    }
  }

  #shouldHideDirectoryFriends() {
    return localStorage.getItem(this.storageKey) == "true";
  }
}
