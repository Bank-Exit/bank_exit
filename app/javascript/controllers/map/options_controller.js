import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["fitBounds", "gestureHandling"];

  connect() {
    if (localStorage.getItem("force-fit-bounds") == "true") {
      this.fitBoundsTarget.checked = true;
    }

    if (localStorage.getItem("force-gesture-handling") == "true") {
      this.gestureHandlingTarget.checked = true;
    }
  }

  toggleFitBounds(e) {
    if (e.target.checked) {
      localStorage.setItem("force-fit-bounds", true);
    } else {
      localStorage.removeItem("force-fit-bounds");
    }

    this.dispatch("toggleFitBounds", {
      detail: { checked: e.target.checked },
    });
  }

  toggleGestureHandling(e) {
    if (e.target.checked) {
      localStorage.setItem("force-gesture-handling", true);
    } else {
      localStorage.removeItem("force-gesture-handling");
    }

    this.dispatch("toggleGestureHandling");
  }
}
