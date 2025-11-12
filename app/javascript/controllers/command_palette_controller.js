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
    useDebounce(this, { wait: 300 });
    useHotkeys(this, {
      "meta+k": [this.open], // Cmd+K
      "ctrl+k": [this.open], // Ctrl+K
      escape: [this.close],
      arrowdown: [this.forwardTab],
      arrowup: [this.backwardTab],
    });

    this.inputTarget.addEventListener("keydown", (e) => {
      if (e.key === "ArrowDown") {
        e.preventDefault();
        this.forwardTab(e);
      } else if (e.key === "ArrowUp") {
        e.preventDefault();
        this.backwardTab(e);
      }
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

  forwardTab(e) {
    if (!this.element.open) return;
    if (e.ctrlKey || e.metaKey || e.altKey) return;
    e.preventDefault();
    this.simulateTabPress();
  }

  backwardTab(e) {
    if (!this.element.open) return;
    if (e.ctrlKey || e.metaKey || e.altKey) return;
    e.preventDefault();
    this.simulateTabPress(true);
  }

  simulateTabPress(shift = false) {
    const focusable = Array.from(
      this.element.querySelectorAll(
        'input, button, [href], select, textarea, [tabindex]:not([tabindex="-1"])',
      ),
    ).filter((el) => !el.disabled && el.offsetParent !== null);

    const index = focusable.indexOf(document.activeElement);
    let nextIndex;

    if (shift) {
      nextIndex = index <= 0 ? focusable.length - 1 : index - 1;
    } else {
      nextIndex = index === focusable.length - 1 ? 0 : index + 1;
    }

    focusable[nextIndex]?.focus();
  }
}
