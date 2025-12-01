import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.menus = [...this.element.querySelectorAll("details")];

    document.addEventListener("click", this.handleClick.bind(this));

    this.menus.forEach((details) =>
      details.addEventListener("toggle", () => this.sync(details)),
    );
  }

  disconnect() {
    document.removeEventListener("click", this.handleClick.bind(this));
  }

  sync(opened) {
    if (!opened.open) {
      return;
    }

    for (const menu of this.menus) {
      if (menu !== opened) {
        menu.open = false;
      }
    }
  }

  handleClick(event) {
    const clickedMenu = event.target.closest("details");

    if (clickedMenu && this.menus.includes(clickedMenu)) {
      return;
    }

    for (const menu of this.menus) {
      menu.open = false;
    }
  }
}
