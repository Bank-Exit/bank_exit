import { Controller } from "@hotwired/stimulus";
import { useDebounce } from "stimulus-use";

export default class extends Controller {
  static targets = ["input", "select"];
  static debounces = ["onUserInput", "clearField"];
  static classes = ["highlight"];

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

    this.selectTargets.forEach((select) => {
      this.updateBackground(select);
      select.addEventListener("change", () => this.updateBackground(select));
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
      const inputs = Array.from(
        form.querySelectorAll(`[name="${CSS.escape(key)}"]`),
      );
      const isArrayField = key.endsWith("[]");

      const matchingInput = inputs.find((input) => input.value === value);
      if (!matchingInput) continue;

      const isCheckbox = matchingInput.type === "checkbox";
      const isChecked = isCheckbox ? matchingInput.checked : true;
      const isFilled = value !== null && value.toString().trim() !== "";
      const isDefaultBlank = matchingInput.tagName === "SELECT" && value === "";

      if (isChecked && isFilled && !isDefaultBlank) {
        if (isArrayField) {
          newParams.append(key, value);
        } else {
          newParams.set(key, value);
        }
      }
    }

    const url = new URL(window.location.href);
    url.search = newParams.toString();

    window.history.pushState({ path: url.href }, "", url.href);

    // Inject filters GET params to download merchants link
    const $downloadLink = document.getElementById("download_merchants");
    const baseUrl = $downloadLink.href.split("?")[0];
    const newHref = `${baseUrl}${url.search}`;
    $downloadLink.href = newHref;
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

      input.classList.remove(...this.highlightClasses);
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

    const select = document.querySelector('select[name="category"]');
    this.updateBackground(select);
  }

  // Synchronize checked quick category input
  // with select category option to reflect selection
  syncSelectCategories(e) {
    const select = document.querySelector('select[name="category"]');

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

    this.updateBackground(select);
  }

  updateBackground(select) {
    if (select.value === "") {
      select.classList.remove(...this.highlightClasses);
    } else {
      select.classList.add(...this.highlightClasses);
    }
  }
}
