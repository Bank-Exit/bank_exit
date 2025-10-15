import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    document.addEventListener("keydown", (e) => {
      // Skip form input listener
      const tag = document.activeElement.tagName.toLowerCase();
      const isTyping =
        ["input", "textarea"].includes(tag) ||
        document.activeElement.isContentEditable;

      if (!isTyping && e.key === "?") {
        this.open(e);
      }
    });

    window.addEventListener("help:open", this.open.bind(this));
  }

  disconnect() {
    window.removeEventListener("help:open", this.open.bind(this));
  }

  open(e) {
    e.preventDefault();

    if (!this.element.isConnected) {
      return;
    }

    if (this.element.open) {
      this.close();
    } else {
      this.element.showModal();
    }
  }

  close() {
    this.element.close();
  }
}
