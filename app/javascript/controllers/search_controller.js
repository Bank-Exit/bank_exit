import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "toggleSearch"];
  static values = {
    showSearch: String,
    hideSearch: String,
  };

  connect() {
    if (sessionStorage.getItem("hideSearch")) {
      this.toggleSearchForm();
    }
  }

  toggleSearchForm() {
    if (this.formTarget.classList.contains("hidden")) {
      this.formTarget.classList.remove("hidden");
      this.toggleSearchTarget.innerText = this.hideSearchValue;
      sessionStorage.removeItem("hideSearch");
    } else {
      this.formTarget.classList.add("hidden");
      this.toggleSearchTarget.innerText = this.showSearchValue;
      sessionStorage.setItem("hideSearch", true);
    }
  }
}
