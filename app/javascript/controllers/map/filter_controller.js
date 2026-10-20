import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];
  static classes = ["highlight"];

  connect() {
    this.handleSubmitEnd = this.#handleSubmitEnd.bind(this);

    this.element.addEventListener("turbo:submit-end", this.handleSubmitEnd);

    this.inputTargets.forEach((input) => {
      if (input.type !== "checkbox") {
        this.updateBackground(input);
        input.addEventListener("change", () => this.updateBackground(input));
      }
    });
  }

  disconnect() {
    this.element.removeEventListener("turbo:submit-end", this.handleSubmitEnd);
  }

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
    if (select.value === "" || select.value == null) {
      select.classList.remove(...this.highlightClasses);
    } else {
      select.classList.add(...this.highlightClasses);
    }
  }

  clear(event) {
    event.preventDefault();

    const form = this.element;

    form.reset();

    form.querySelectorAll("input, textarea, select").forEach((field) => {
      if (field.type === "checkbox" || field.type === "radio") {
        field.checked = false;
      } else if (field.tagName === "SELECT") {
        field.selectedIndex = 0;
        this.updateBackground(field);
      } else if (
        field.type !== "button" &&
        field.type !== "submit" &&
        field.type !== "reset"
      ) {
        field.value = "";
      }
    });

    this.element.requestSubmit();
  }

  #handleSubmitEnd() {
    this.#updateBrowserUrl();
    this.dispatch("mapCollapsed");
  }
}
