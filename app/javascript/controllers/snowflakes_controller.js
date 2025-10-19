import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["snow", "input"];

  connect() {
    const withSnowflakes = localStorage.getItem("with-snowflakes") || "true";

    this.inputTarget.checked = withSnowflakes === "true";
  }

  switch() {
    const isChecked = this.inputTarget.checked;

    if (!isChecked) {
      document.documentElement.classList.add("snow-disabled");
    } else {
      document.documentElement.classList.remove("snow-disabled");
    }

    localStorage.setItem("with-snowflakes", isChecked);
  }
}
