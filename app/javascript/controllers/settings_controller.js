import { Controller } from "@hotwired/stimulus";

const STORAGE_KEY = "has-shortcuts";

export default class extends Controller {
  connect() {
    const enabled = localStorage.getItem(STORAGE_KEY) === "true";
    this.element.classList.toggle("has-shortcuts", enabled);
  }

  toggleKeyboardNav() {
    const enabled = this.element.classList.toggle("has-shortcuts");
    localStorage.setItem(STORAGE_KEY, enabled);
  }
}
