import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    modelId: String,
    rememberHideAfterClose: { type: Boolean, default: true },
  };

  connect() {
    if (this.rememberHideAfterCloseValue) {
      this.localKey = `hide-announcement-${this.modelIdValue}`;

      if (localStorage.getItem(this.localKey)) {
        this.element.remove();
      } else {
        this.element.classList.remove("hidden");
      }
    } else {
      this.element.classList.remove("hidden");
    }
  }

  openLink(e) {
    if (this.rememberHideAfterCloseValue) {
      localStorage.setItem(this.localKey, true);
    }

    Turbo.visit(e.target.href);
  }

  hide(_e) {
    this.element.remove();

    if (this.rememberHideAfterCloseValue) {
      localStorage.setItem(this.localKey, true);
    }
  }
}
