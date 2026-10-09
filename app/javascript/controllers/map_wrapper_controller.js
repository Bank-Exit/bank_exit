import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggleExpandButton", "maximizeIcon", "minimizeIcon"];

  static values = {
    expandLabel: String,
    collapseLabel: String,
  };

  toggleExpand() {
    this.element.classList.toggle("is-expanded");

    this.maximizeIconTarget.classList.toggle("hidden");
    this.minimizeIconTarget.classList.toggle("hidden");

    const expanded = this.element.classList.contains("is-expanded");

    this.toggleExpandButtonTarget.setAttribute(
      "title",
      expanded ? this.collapseLabelValue : this.expandLabelValue,
    );
    this.toggleExpandButtonTarget.setAttribute(
      "aria-expanded",
      String(expanded),
    );
  }

  onMapCollapsed() {
    this.element.classList.remove("is-expanded");
    this.toggleExpandButtonTarget.setAttribute("title", this.expandLabelValue);
    this.toggleExpandButtonTarget.setAttribute("aria-expanded", "false");
  }
}
