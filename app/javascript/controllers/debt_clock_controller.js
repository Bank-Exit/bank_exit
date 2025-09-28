import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    d0: Number, // Initial debt amount in euros (at the reference timestamp)
    t0: Number, // Reference timestamp in Unix seconds (when the debt was d0)
    rate: Number, // Growth rate in euros per second (how fast the debt increases)
    locale: { type: String, value: "en" }, // Locale code for formatting (e.g., 'fr-FR', 'en-US')
  };

  static targets = ["amount"];

  connect() {
    this.startTime = Date.now() / 1000;
    this.initialValue =
      this.d0Value + this.rateValue * (this.startTime - this.t0Value);
    this._tick();
  }

  _tick() {
    const now = Date.now() / 1000;
    const elapsed = now - this.startTime;
    const currentValue = this.initialValue + this.rateValue * elapsed;
    this.amountTarget.textContent = this.formatEuro(currentValue);
    requestAnimationFrame(this._tick.bind(this));
  }

  formatEuro(value) {
    return value.toLocaleString(this.localeValue, {
      style: "currency",
      currency: "EUR",
      maximumFractionDigits: 0,
    });
  }
}
