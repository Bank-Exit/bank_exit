import { Control } from "leaflet";

// --------------------------------------------------
// CSS injection
// --------------------------------------------------

const CSS = `
.leaflet-control-fullscreen-button {
    display: flex !important;
    align-items: center;
    justify-content: center;
    width: 30px;
    height: 30px;
    color: #333;
    background: white;
    cursor: pointer;
    text-decoration: none;
}

.leaflet-control-fullscreen-button:hover {
    background: #f4f4f4;
}

.leaflet-pseudo-fullscreen {
    position: fixed !important;
    inset: 0 !important;
    width: 100vw !important;
    height: 100vh !important;
    z-index: 99999 !important;
}

body.leaflet-fullscreen-active {
    overflow: hidden;
}

.leaflet-control-fullscreen-separate {
    clear: none !important;
}

/* Dark theme */

.dark .leaflet-control-fullscreen-button {
    color: #e5e7eb;
    background: #1f2937;
    border-color: #374151;
}

.dark .leaflet-control-fullscreen-button:hover {
    background: #374151;
}

@media (prefers-color-scheme: dark) {
    .leaflet-control-fullscreen-button {
        color: #e5e7eb;
        background: #1f2937;
        border-color: #374151;
    }

    .leaflet-control-fullscreen-button:hover {
        background: #374151;
    }
}
`;

const STYLE_ID = "leaflet-fullscreen-styles";

function injectStyles() {
  if (document.getElementById(STYLE_ID)) return;

  const style = document.createElement("style");
  style.id = STYLE_ID;
  style.textContent = CSS;

  document.head.appendChild(style);
}

// --------------------------------------------------
// SVG icons
// --------------------------------------------------

const ENTER_ICON = `
<svg viewBox="0 0 24 24"
     width="18" height="18"
     fill="none"
     stroke="currentColor"
     stroke-width="2"
     stroke-linecap="round"
     stroke-linejoin="round">
    <path d="M8 3H3v5 M16 3h5v5 M3 16v5h5 M21 16v5h-5"/>
</svg>
`;

const EXIT_ICON = `
<svg viewBox="0 0 24 24"
     width="18" height="18"
     fill="none"
     stroke="currentColor"
     stroke-width="2"
     stroke-linecap="round"
     stroke-linejoin="round">
    <path d="M3 8V3h5 M16 3h5v5 M8 21H3v-5 M21 16v5h-5"/>
</svg>
`;

// --------------------------------------------------
// Fullscreen Control
// --------------------------------------------------

export class FullscreenControl extends Control {
  constructor(options = {}) {
    super({
      position: "topleft",
      title: "Plein écran",
      titleCancel: "Quitter le plein écran",
      forcePseudoFullscreen: false,
      forceSeparateButton: false,
      ...options,
    });

    this._button = null;
    this._isFullscreen = false;
    this._pseudoContainer = null;

    this._onFullscreenChange = this._onFullscreenChange.bind(this);

    this._onButtonClick = this._onButtonClick.bind(this);
  }

  // ----------------------------------------------
  // Add control to map
  // ----------------------------------------------

  onAdd(map) {
    injectStyles();

    this._map = map;

    const container = document.createElement("div");

    container.className = "leaflet-control-fullscreen leaflet-bar";

    if (this.options.forceSeparateButton) {
      container.classList.add("leaflet-control-fullscreen-separate");
    }

    const button = document.createElement("a");

    button.href = "#";

    button.className = "leaflet-control-fullscreen-button";

    button.setAttribute("role", "button");
    button.setAttribute("aria-pressed", "false");

    button.addEventListener("click", this._onButtonClick);

    container.appendChild(button);

    this._button = button;

    this._controlContainer = container;

    document.addEventListener("fullscreenchange", this._onFullscreenChange);

    this._updateButton();

    return container;
  }

  // ----------------------------------------------
  // Remove control from map
  // ----------------------------------------------

  onRemove() {
    document.removeEventListener("fullscreenchange", this._onFullscreenChange);

    this._button?.removeEventListener("click", this._onButtonClick);

    // Exit fullscreen if this control is removed.
    if (this._isFullscreen) {
      if (document.fullscreenElement) {
        document.exitFullscreen().catch(() => {});
      }

      this._exitPseudoFullscreen();
    }

    this._button = null;
    this._controlContainer = null;

    // IMPORTANT:
    // Do not set this._map = null here.
    // Leaflet's Control.remove() still needs it.
  }

  // ----------------------------------------------
  // Button click
  // ----------------------------------------------

  _onButtonClick(event) {
    event.preventDefault();

    this.toggleFullscreen();
  }

  // ----------------------------------------------
  // Toggle fullscreen
  // ----------------------------------------------

  async toggleFullscreen() {
    const container = this._map?.getContainer();

    if (!container) return;

    try {
      if (this._isFullscreen) {
        if (document.fullscreenElement) {
          await document.exitFullscreen();
        } else {
          this._exitPseudoFullscreen();
        }
      } else if (
        !this.options.forcePseudoFullscreen &&
        container.requestFullscreen
      ) {
        await container.requestFullscreen();
      } else {
        this._enterPseudoFullscreen();
      }
    } catch (error) {
      console.error("Leaflet Fullscreen:", error);
    }
  }

  // ----------------------------------------------
  // Enter pseudo fullscreen
  // ----------------------------------------------

  _enterPseudoFullscreen() {
    const container = this._map?.getContainer();

    if (!container) return;

    this._pseudoContainer = container;

    container.classList.add("leaflet-pseudo-fullscreen");

    document.body.classList.add("leaflet-fullscreen-active");

    this._isFullscreen = true;

    this._updateButton();

    this._map.invalidateSize();
  }

  // ----------------------------------------------
  // Exit pseudo fullscreen
  // ----------------------------------------------

  _exitPseudoFullscreen() {
    const container = this._pseudoContainer;

    if (container) {
      container.classList.remove("leaflet-pseudo-fullscreen");
    }

    document.body.classList.remove("leaflet-fullscreen-active");

    this._pseudoContainer = null;

    this._isFullscreen = false;

    this._updateButton();

    this._map?.invalidateSize();
  }

  // ----------------------------------------------
  // Native fullscreen change
  // ----------------------------------------------

  _onFullscreenChange() {
    const container = this._map?.getContainer();

    if (!container) return;

    this._isFullscreen = document.fullscreenElement === container;

    if (!this._isFullscreen) {
      document.body.classList.remove("leaflet-fullscreen-active");
    }

    this._updateButton();

    this._map.invalidateSize();
  }

  // ----------------------------------------------
  // Update button
  // ----------------------------------------------

  _updateButton() {
    if (!this._button) return;

    this._button.innerHTML = this._isFullscreen ? EXIT_ICON : ENTER_ICON;

    this._button.title = this._isFullscreen
      ? this.options.titleCancel
      : this.options.title;

    this._button.setAttribute("aria-label", this._button.title);

    this._button.setAttribute("aria-pressed", String(this._isFullscreen));
  }
}

// --------------------------------------------------
// Default export
// --------------------------------------------------

export default FullscreenControl;
