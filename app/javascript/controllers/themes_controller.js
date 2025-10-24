import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    light: { type: String, default: "silk" },
    dark: { type: String, default: "dracula" },
  };

  connect() {
    const allowedValues = [this.lightValue, this.darkValue];
    let currentTheme = localStorage.getItem("color-theme");

    if (currentTheme && allowedValues.includes(currentTheme)) {
      this.element.checked = currentTheme === this.darkValue;
    } else {
      currentTheme = this.lightValue;
      localStorage.setItem("color-theme", currentTheme);
      this.element.checked = false;
    }
  }

  switch() {
    const isChecked = this.element.checked;
    const newTheme = isChecked ? this.darkValue : this.lightValue;

    document.documentElement.setAttribute("data-theme", newTheme);
    localStorage.setItem("color-theme", newTheme);
  }
}
