import { useDebounce, ApplicationController } from "stimulus-use";

export default class extends ApplicationController {
  static targets = [
    "form",
    "toggleSearch",
    "query",
    "category",
    "country",
    "continent",
  ];
  static debounces = ["submit"];
  static values = {
    showSearch: String,
    hideSearch: String,
  };

  connect() {
    useDebounce(this, { wait: 400 });

    if (sessionStorage.getItem("hideSearch")) {
      this.toggleSearchForm();
    }
  }

  // Synchronize select category option with quick
  // checkbox categories to reflect selection
  syncQuickCategories(e) {
    document.querySelectorAll('input[name="category"]').forEach((element) => {
      element.checked = false;
    });

    const currentCategory = e.target.value;
    const quickCategory = document.querySelector(
      `input[name="category"][value="${currentCategory}"]`,
    );

    if (quickCategory) {
      quickCategory.checked = true;
    }
  }

  // Synchronize checked quick category input
  // with select category option to reflect selection
  syncSelectCategories(e) {
    if (e.target.checked) {
      document.querySelectorAll('input[name="category"]').forEach((element) => {
        element.checked = false;
      });

      const currentCategory = e.target.value;
      document.querySelector(`option[value="${currentCategory}"]`).selected =
        true;

      e.target.checked = true;
    } else {
      document.querySelector('option[value="all"]').selected = true;
    }
  }

  // TODO: Find a way to clean this mess ^^
  submit(e) {
    // Do not submit on following keyboard keys combination
    if (
      e.key == "Tab" ||
      (e.shiftKey && e.key == "Tab") || // Shift+Tab
      (e.ctrlKey && e.key == "ArrowLeft") || // Ctrl+Left
      (e.ctrlKey && e.key == "ArrowRight") // Ctrl+Right
    ) {
      return;
    }

    // Do not submit on query input with following keyboard
    // keys combination
    if (e.target == this.queryTarget) {
      if (
        (e.target.value.length < 3 && e.target.value != "") ||
        e.key == "ArrowLeft" ||
        e.key == "ArrowRight" ||
        e.key == "Enter"
      ) {
        return;
      }
    } else if (
      e.target.type === "checkbox" ||
      (e.target.previousSibling && e.target.previousSibling.type === "checkbox")
    ) {
      // If item is a checkbox (quick categories or coins),
      // trigger click on it to select it
      if (e.key == "Enter") {
        e.target.click();
      }
    }

    const formData = new FormData(this.formTarget);
    formData.delete("category"); // Double category params in URL

    if (this.queryTarget.value.length == 0) {
      formData.delete("search");
    }

    if (this.categoryTarget.value != "all") {
      formData.append("category", this.categoryTarget.value);
    }

    if (this.countryTarget.value.length == 0) {
      formData.delete("country");
    }

    if (this.continentTarget.value.length == 0) {
      formData.delete("continent");
    }

    // Continent resets country params
    if (e.target.name == "continent") {
      formData.delete("country");
      this.countryTarget.selectedIndex = 0;
    }

    // Coountry resets continent params
    if (e.target.name == "country") {
      formData.delete("continent");
      this.continentTarget.selectedIndex = 0;
    }

    const params = new URLSearchParams(formData);
    let url = new URL(this.formTarget.action + "&" + params);

    if (url.href.endsWith("&")) {
      url = new URL(url.href.slice(0, -1));
    }

    window.history.pushState({ path: url.href }, "", url.href);

    this.formTarget.requestSubmit();
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

  clearQuery(e) {
    if (this.queryTarget.value.length > 0) {
      this.queryTarget.value = "";
      this.submit(e);
    }
  }

  clearCategory(e) {
    if (this.categoryTarget.value !== "all") {
      this.categoryTarget.selectedIndex = 0;
      this.syncQuickCategories(e);
      this.submit(e);
    }
  }

  clearCountry(e) {
    if (this.countryTarget.value !== "all") {
      this.countryTarget.selectedIndex = 0;
      this.submit(e);
    }
  }

  clearContinent(e) {
    if (this.continentTarget.value !== "all") {
      this.continentTarget.selectedIndex = 0;
      this.submit(e);
    }
  }
}
