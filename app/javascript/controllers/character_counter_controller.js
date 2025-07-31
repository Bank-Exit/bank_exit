import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["textarea", "counter"];
  static values = {
    maxCounter: { type: Number, default: 255 },
  };
  static classes = ["within", "near", "out"];

  change(e) {
    this.counter = e.target.value.length;
    this.counterTarget.innerText = this.counter;

    this.#updateCounter(this.counter);
  }

  #updateCounter(currentCounter) {
    this.counterTarget.classList.remove(this.withinClass);
    this.counterTarget.classList.remove(this.nearClass);
    this.counterTarget.classList.remove(this.outClass);

    if (currentCounter < 50) {
      this.counterTarget.classList.add(this.nearClass);
    } else if (currentCounter < this.maxCounterValue) {
      this.counterTarget.classList.add(this.withinClass);
    } else {
      this.counterTarget.classList.add(this.outClass);
    }
  }
}
