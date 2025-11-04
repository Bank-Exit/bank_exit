// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

import * as L from "leaflet";
import TurboPower from "turbo_power";

TurboPower.initialize(Turbo.StreamActions);

// Prevent scrolling to anchor on map actions (zoom)
L.Control.prototype._refocusOnMap = function _refocusOnMap() {};

// @see https://gorails.com/episodes/custom-hotwire-turbo-confirm-modals
Turbo.config.forms.confirm = (message, element) => {
  let dialog = document.getElementById("turbo-confirm");

  const $body = dialog.querySelector(".body");
  $body.classList.add("text-center");
  $body.innerHTML = message;

  dialog.showModal();

  return new Promise((resolve, reject) => {
    dialog.addEventListener(
      "close",
      () => {
        resolve(dialog.returnValue == "confirm");
      },
      { once: true },
    );
  });
};

window.addEventListener("click", function (e) {
  document.querySelectorAll(".dropdown").forEach(function (dropdown) {
    if (!dropdown.contains(e.target)) {
      // Click was outside the dropdown, close it
      dropdown.open = false;
    }
  });
});

// This patch makes dropdown with popover aware of page
// bottom in order to render menu in a top position.
document.addEventListener("turbo:load", () => {
  const triggerButtons = document.querySelectorAll("[popovertarget]");

  triggerButtons.forEach((button) => {
    const popoverId = button.getAttribute("popovertarget");
    const popover = document.getElementById(popoverId);

    if (!popover) return;

    button.addEventListener("click", () => {
      requestAnimationFrame(() => {
        const rect = button.getBoundingClientRect();
        const menuHeight = popover.offsetHeight || 150;

        const spaceBelow = window.innerHeight - rect.bottom;

        if (spaceBelow < menuHeight + 16) {
          popover.classList.add("dropdown-top");
        } else {
          popover.classList.remove("dropdown-top");
        }
      });
    });
  });
});

// After a Turbo navigation, <track> subtitles often disappear because
// the <video> element persists in memory. Cloning it forces the browser
// to re-parse the <track> elements and reload subtitles properly.
document.addEventListener("turbo:render", (e) => {
  const video = document.querySelector("video[data-reload-subtitles]");
  if (!video) return;

  const clone = video.cloneNode(true);
  video.parentNode.replaceChild(clone, video);
});
