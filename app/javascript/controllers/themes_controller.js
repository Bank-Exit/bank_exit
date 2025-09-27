import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const currentTheme = localStorage.getItem("color-theme") || "silk";

    this.element.checked = currentTheme === "dracula";
  }

  switch() {
    const isChecked = this.element.checked;
    const newTheme = isChecked ? "dracula" : "silk";

    document.documentElement.setAttribute("data-theme", newTheme);
    localStorage.setItem("color-theme", newTheme);
  }
}
