import { Controller } from "@hotwired/stimulus";
import { useHotkeys } from "stimulus-use/hotkeys";

export default class extends Controller {
  static targets = ["pagyTop"];

  connect() {
    useHotkeys(this, {
      "ctrl+left": [this.#prevPageHandler],
      "ctrl+right": [this.#nextPageHandler],
    });
  }

  addPageToURL(e) {
    let current = new URL(window.location.href);

    let number = e.target.text;

    if (number == "<" || number == ">") {
      const currentNumber = document.querySelector(
        'a[role="link"].current',
      ).text;

      if (number == "<") {
        number = parseInt(currentNumber) - 1;
      } else {
        number = parseInt(currentNumber) + 1;
      }
    }

    current.searchParams.set("page", number);
    window.history.pushState("id", "", current);

    if (this.hasPagyTopTarget) {
      this.#scrollToTopResults();
    }
  }

  #prevPageHandler(e) {
    const $nav = document.querySelector("nav.pagy");

    if ($nav == null) {
      return;
    }

    $nav.firstChild.click();
  }

  #nextPageHandler(e) {
    const $nav = document.querySelector("nav.pagy");

    if ($nav == null) {
      return;
    }

    $nav.lastChild.click();
  }

  #scrollToTopResults() {
    this.pagyTopTarget.scrollIntoView({ behavior: "smooth", block: "start" });
  }
}
