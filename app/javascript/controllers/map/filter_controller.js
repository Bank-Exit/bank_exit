import { Controller } from "@hotwired/stimulus";
import { useDebounce } from "stimulus-use";

export default class extends Controller {
  static targets = ["input"];
  static debounces = ["onUserInput", "clearField"];

  connect() {
    useDebounce(this, { wait: 300 });

    this.inputTargets.forEach((input) => {
      const isCheckbox = input.type === "checkbox";
      const isRadio = input.type === "radio";
      const isSelect = input.tagName === "SELECT";

      if (isCheckbox || isRadio || isSelect) {
        input.addEventListener("change", this.#onUserInput);
      } else {
        input.addEventListener("input", this.#onUserInput);
        input.addEventListener("keydown", this.#ignoreNavigationKeys);
      }
    });
  }

  disconnect() {
    this.inputTargets.forEach((input) => {
      input.removeEventListener("change", this.#onUserInput);
      input.removeEventListener("input", this.#onUserInput);
      input.removeEventListener("keydown", this.#ignoreNavigationKeys);
    });
  }

  #ignoreNavigationKeys(event) {
    const navKeys = ["ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight", "Tab"];
    if (navKeys.includes(event.key)) {
      event.stopPropagation();
    }
  }

  #onUserInput = () => {
    this.#updateBrowserUrl();
    this.element.requestSubmit();
  };

  #updateBrowserUrl() {
    const form = this.element;
    const formData = new FormData(form);
    const newParams = new URLSearchParams();

    for (const [key, value] of formData.entries()) {
      const input = form.querySelector(`[name="${CSS.escape(key)}"]`);

      const isCheckbox = input?.type === "checkbox";
      const isChecked = isCheckbox ? input.checked : true;
      const isFilled = value !== null && value.toString().trim() !== "";
      const isDefaultBlank = input?.tagName === "SELECT" && value === "";

      if (isChecked && isFilled && !isDefaultBlank) {
        newParams.set(key, value);
      }
    }

    const url = new URL(window.location.href);
    url.search = newParams.toString();

    window.history.pushState({ path: url.href }, "", url.href);
  }

  clearField(event) {
    if (event.type === "keydown") {
      if (event.key !== "Enter" && event.key !== " ") return;
      event.preventDefault();
    }

    const fieldName =
      event.target.dataset.resetable ||
      event.target.parentElement.dataset.resetable;
    if (!fieldName) return;

    const inputs = this.inputTargets.filter(
      (input) =>
        input.name === fieldName || input.name?.startsWith(fieldName + "["),
    );

    if (inputs.length === 0) return;

    let changed = false;

    inputs.forEach((input) => {
      if (input.type === "checkbox" || input.type === "radio") {
        if (input.checked) {
          input.checked = false;
          changed = true;
        }
      } else {
        if (input.value !== "") {
          input.value = "";
          changed = true;
        }
      }
    });

    if (changed) {
      this.#updateBrowserUrl();
      this.element.requestSubmit();
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
      document.querySelector(
        'select[name="category"] option[value=""]',
      ).selected = true;
    }
  }
}
