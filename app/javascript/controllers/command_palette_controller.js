import { Controller } from "@hotwired/stimulus";
import { useDebounce } from "stimulus-use";
import { useHotkeys } from "stimulus-use/hotkeys";
import { get } from "@rails/request.js";

export default class extends Controller {
  static targets = ["input", "results", "spinner"];
  static debounces = ["search"];
  static values = {
    searchUrl: String,
  };

  connect() {
    this.selectedIndex = -1;
    this.items = [];

    useDebounce(this, { wait: 300 });
    useHotkeys(this, {
      "meta+k": [this.open], // Cmd+K
      "ctrl+k": [this.open], // Ctrl+K
      escape: [this.close],
    });

    this.defaultMerchants = this.resultsTarget.innerHTML;

    window.addEventListener("command-palette:open", this.open.bind(this));
  }

  disconnect() {
    window.removeEventListener("command-palette:open", this.open.bind(this));
  }

  open(e) {
    e.preventDefault();

    if (!this.element.isConnected) {
      return;
    }

    this.element.showModal();

    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        this.inputTarget.focus();
      });
    });
  }

  async search() {
    const query = this.inputTarget.value.trim();

    if (query.length < 3) {
      if (this.hasResultsTarget) {
        this.resultsTarget.innerHTML = this.defaultMerchants;
      }

      this.spinnerTarget.classList.add("hidden");
      return;
    }

    this.spinnerTarget.classList.remove("hidden");

    try {
      await get(this.searchUrlValue, {
        query: { query },
        responseKind: "turbo-stream",
      });
    } finally {
      this.spinnerTarget.classList.add("hidden");
    }
  }

  close(e) {
    if (e.target === this.element) {
      this.element.close();
    }
  }
}
