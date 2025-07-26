import { Controller } from "@hotwired/stimulus";
import { post } from "@rails/request.js";

export default class extends Controller {
  static values = {
    toggleUrl: String,
  };

  async switch() {
    const isChecked = this.element.checked;

    const response = await post(this.toggleUrlValue, {
      body: {
        include_atms: isChecked,
      },
    });

    if (response.ok) {
      Turbo.visit(window.location);
    }
  }
}
