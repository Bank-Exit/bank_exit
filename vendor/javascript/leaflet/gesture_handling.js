import { Map } from "leaflet";

// --------------------------------------------------
// CSS injection
// --------------------------------------------------

const STYLE_ID = "leaflet-gesture-handling-styles";

const CSS = `
@keyframes leaflet-gesture-fadein {
    from { opacity: 0; }
    to { opacity: 1; }
}

/*
 * IMPORTANT:
 * Allow native vertical scrolling everywhere inside the map.
 * Do not let Leaflet descendants override this behavior.
 */

.leaflet-container.leaflet-gesture-handling,
.leaflet-container.leaflet-gesture-handling * {
    touch-action: pan-y !important;
}

.leaflet-container.leaflet-gesture-handling {
    overscroll-behavior: auto;
    -webkit-overflow-scrolling: touch;
}

.leaflet-gesture-handling-touch-warning::after,
.leaflet-gesture-handling-scroll-warning::after {
    position: absolute;
    inset: 0;
    z-index: 461;

    display: flex;
    align-items: center;
    justify-content: center;

    padding: 20px;

    color: #fff;
    background: rgba(0, 0, 0, .58);

    font-family: Arial, sans-serif;
    font-size: 18px;
    font-weight: 500;
    line-height: 1.5;
    text-align: center;

    pointer-events: none;

    animation: leaflet-gesture-fadein .2s ease-out;
}

.leaflet-gesture-handling-touch-warning::after {
    content: attr(data-gesture-handling-touch-content);
}

.leaflet-gesture-handling-scroll-warning::after {
    content: attr(data-gesture-handling-scroll-content);
}

/* Dark theme */

.dark .leaflet-gesture-handling-touch-warning::after,
.dark .leaflet-gesture-handling-scroll-warning::after {
    color: #f9fafb;
    background: rgba(15, 23, 42, .82);
}

@media (prefers-color-scheme: dark) {
    .leaflet-gesture-handling-touch-warning::after,
    .leaflet-gesture-handling-scroll-warning::after {
        color: #f9fafb;
        background: rgba(15, 23, 42, .82);
    }
}

@media (prefers-reduced-motion: reduce) {
    .leaflet-gesture-handling-touch-warning::after,
    .leaflet-gesture-handling-scroll-warning::after {
        animation: none;
    }
}
`;

function injectStyles() {
  if (document.getElementById(STYLE_ID)) return;

  const style = document.createElement("style");
  style.id = STYLE_ID;
  style.textContent = CSS;

  document.head.appendChild(style);
}

// --------------------------------------------------
// Translations
// --------------------------------------------------

const TRANSLATIONS = {
  fr: {
    touch: "Utilisez deux doigts pour déplacer la carte",
    scroll: "Utilisez Ctrl + défilement pour zoomer sur la carte",
    scrollMac: "Utilisez ⌘ + défilement pour zoomer sur la carte",
  },

  en: {
    touch: "Use two fingers to move the map",
    scroll: "Use Ctrl + scroll to zoom the map",
    scrollMac: "Use ⌘ + scroll to zoom the map",
  },

  es: {
    touch: "Utilice dos dedos para mover el mapa",
    scroll: "Utilice Ctrl + desplazamiento para ampliar el mapa",
    scrollMac: "Utilice ⌘ + desplazamiento para ampliar el mapa",
  },

  it: {
    touch: "Usa due dita per spostare la mappa",
    scroll: "Usa Ctrl + rotellina per ingrandire la mappa",
    scrollMac: "Usa ⌘ + rotellina per ingrandire la mappa",
  },

  de: {
    touch: "Verwenden Sie zwei Finger, um die Karte zu bewegen",
    scroll: "Verwenden Sie Strg + Scrollen zum Zoomen",
    scrollMac: "Verwenden Sie ⌘ + Scrollen zum Zoomen",
  },
};

// --------------------------------------------------
// Language detection
// --------------------------------------------------

function detectLanguage(locale = null) {
  if (locale) {
    const language = locale.toLowerCase().split(/[-_]/)[0];

    return TRANSLATIONS[language] ? language : "en";
  }

  const languages = [...(navigator.languages || []), navigator.language].filter(
    Boolean,
  );

  for (const locale of languages) {
    const language = locale.toLowerCase().split(/[-_]/)[0];

    if (TRANSLATIONS[language]) {
      return language;
    }
  }

  return "en";
}

// --------------------------------------------------
// Gesture Handling
// --------------------------------------------------

export class GestureHandling {
  constructor(map, options = {}) {
    this._map = map;

    this.options = {
      duration: 1000,
      locale: null,
      text: {},
      ...options,
    };

    this._enabled = false;

    this._scrollTimeout = null;
    this._wheelZoomTimeout = null;

    this._touchCount = 0;

    this._container = map.getContainer();

    // Preserve initial map settings.
    this._originalDragging = map.dragging?.enabled() ?? false;

    this._originalScrollWheel = map.scrollWheelZoom?.enabled() ?? false;

    // Bind callbacks.
    this._handleWheel = this._handleWheel.bind(this);

    this._handleTouchStart = this._handleTouchStart.bind(this);

    this._handleTouchMove = this._handleTouchMove.bind(this);

    this._handleTouchEnd = this._handleTouchEnd.bind(this);

    this._handleTouchCancel = this._handleTouchCancel.bind(this);

    this._handleMapUnload = this._handleMapUnload.bind(this);

    this._setLanguageContent();
  }

  // ----------------------------------------------
  // Language
  // ----------------------------------------------

  _setLanguageContent() {
    this._language = detectLanguage(this.options.locale);

    const translations = TRANSLATIONS[this._language];

    const text = {
      ...translations,
      ...this.options.text,
    };

    const isMac = /Mac|iPhone|iPad|iPod/i.test(
      navigator.userAgentData?.platform ||
        navigator.platform ||
        navigator.userAgent,
    );

    this._container.setAttribute(
      "data-gesture-handling-touch-content",
      text.touch,
    );

    this._container.setAttribute(
      "data-gesture-handling-scroll-content",
      isMac ? text.scrollMac : text.scroll,
    );
  }

  // ----------------------------------------------
  // Enable
  // ----------------------------------------------

  enable() {
    if (this._enabled || !this._map) {
      return this;
    }

    injectStyles();

    this._enabled = true;

    this._container.classList.add("leaflet-gesture-handling");

    // Disable standard wheel zoom.
    this._map.scrollWheelZoom?.disable();

    // Desktop wheel.
    this._container.addEventListener("wheel", this._handleWheel, {
      passive: false,
    });

    /*
     * Touch events.
     *
     * Capture phase is essential:
     * Our handlers run before Leaflet handlers.
     */

    this._container.addEventListener("touchstart", this._handleTouchStart, {
      passive: true,
      capture: true,
    });

    this._container.addEventListener("touchmove", this._handleTouchMove, {
      passive: false,
      capture: true,
    });

    this._container.addEventListener("touchend", this._handleTouchEnd, {
      passive: true,
      capture: true,
    });

    this._container.addEventListener("touchcancel", this._handleTouchCancel, {
      passive: true,
      capture: true,
    });

    this._map.on("unload", this._handleMapUnload);

    return this;
  }

  // ----------------------------------------------
  // Disable
  // ----------------------------------------------

  disable() {
    if (!this._enabled) return this;

    this._enabled = false;

    clearTimeout(this._scrollTimeout);
    clearTimeout(this._wheelZoomTimeout);

    this._container.removeEventListener("wheel", this._handleWheel);

    // Remove capture listeners.
    this._container.removeEventListener(
      "touchstart",
      this._handleTouchStart,
      true,
    );

    this._container.removeEventListener(
      "touchmove",
      this._handleTouchMove,
      true,
    );

    this._container.removeEventListener("touchend", this._handleTouchEnd, true);

    this._container.removeEventListener(
      "touchcancel",
      this._handleTouchCancel,
      true,
    );

    this._map.off("unload", this._handleMapUnload);

    this._container.classList.remove("leaflet-gesture-handling");

    this._removeWarnings();

    // Restore original dragging state.
    if (this._originalDragging) {
      this._map.dragging?.enable();
    } else {
      this._map.dragging?.disable();
    }

    // Restore original wheel zoom state.
    if (this._originalScrollWheel) {
      this._map.scrollWheelZoom?.enable();
    } else {
      this._map.scrollWheelZoom?.disable();
    }

    this._touchCount = 0;

    return this;
  }

  // ----------------------------------------------
  // Toggle
  // ----------------------------------------------

  toggle() {
    return this._enabled ? this.disable() : this.enable();
  }

  // ----------------------------------------------
  // State
  // ----------------------------------------------

  enabled() {
    return this._enabled;
  }

  get isEnabled() {
    return this._enabled;
  }

  get language() {
    return this._language;
  }

  // ----------------------------------------------
  // Desktop: Ctrl / Cmd + wheel
  // ----------------------------------------------

  _handleWheel(event) {
    if (!this._enabled) return;

    if (event.ctrlKey || event.metaKey) {
      if (event.cancelable) {
        event.preventDefault();
      }

      this._removeScrollWarning();

      this._map.scrollWheelZoom?.enable();

      clearTimeout(this._wheelZoomTimeout);

      this._wheelZoomTimeout = setTimeout(() => {
        if (!this._enabled) return;

        this._map.scrollWheelZoom?.disable();
      }, 250);
    } else {
      this._map.scrollWheelZoom?.disable();

      this._showScrollWarning();
    }
  }

  // ----------------------------------------------
  // Touch start
  // ----------------------------------------------

  _handleTouchStart(event) {
    if (!this._enabled) return;

    this._touchCount = event.touches.length;

    if (this._touchCount === 1) {
      /*
       * ONE FINGER
       *
       * Disable Leaflet dragging before its handlers.
       * Do not preventDefault.
       * Do not stopPropagation.
       *
       * Browser handles native page scrolling.
       */

      this._map.dragging?.disable();

      this._showTouchWarning();
    } else if (this._touchCount >= 2) {
      /*
       * TWO FINGERS
       *
       * Allow Leaflet gestures.
       */

      this._removeTouchWarning();

      if (this._originalDragging) {
        this._map.dragging?.enable();
      }
    }
  }

  // ----------------------------------------------
  // Touch move
  // ----------------------------------------------

  _handleTouchMove(event) {
    if (!this._enabled) return;

    this._touchCount = event.touches.length;

    if (this._touchCount >= 2) {
      /*
       * TWO FINGERS
       *
       * Prevent native page scrolling.
       * Leaflet handles map dragging and pinch zoom.
       */

      if (event.cancelable) {
        event.preventDefault();
      }

      this._removeTouchWarning();

      if (this._originalDragging) {
        this._map.dragging?.enable();
      }
    } else {
      /*
       * ONE FINGER
       *
       * NEVER preventDefault.
       * NEVER stopPropagation.
       * NEVER enable Leaflet dragging.
       *
       * Native browser scrolling only.
       */

      this._map.dragging?.disable();

      this._showTouchWarning();
    }
  }

  // ----------------------------------------------
  // Touch end
  // ----------------------------------------------

  _handleTouchEnd(event) {
    if (!this._enabled) return;

    this._touchCount = event.touches.length;

    if (this._touchCount === 1) {
      /*
       * Back to one finger.
       * Disable Leaflet dragging immediately.
       */

      this._map.dragging?.disable();

      this._showTouchWarning();
    } else if (this._touchCount === 0) {
      this._removeTouchWarning();

      if (this._originalDragging) {
        this._map.dragging?.enable();
      }
    }
  }

  // ----------------------------------------------
  // Touch cancel
  // ----------------------------------------------

  _handleTouchCancel() {
    if (!this._enabled) return;

    this._touchCount = 0;

    if (this._originalDragging) {
      this._map.dragging?.enable();
    } else {
      this._map.dragging?.disable();
    }

    this._removeTouchWarning();
  }

  // ----------------------------------------------
  // Warnings
  // ----------------------------------------------

  _showTouchWarning() {
    this._container.classList.add("leaflet-gesture-handling-touch-warning");
  }

  _removeTouchWarning() {
    this._container.classList.remove("leaflet-gesture-handling-touch-warning");
  }

  _showScrollWarning() {
    this._container.classList.add("leaflet-gesture-handling-scroll-warning");

    clearTimeout(this._scrollTimeout);

    this._scrollTimeout = setTimeout(() => {
      this._removeScrollWarning();
    }, this.options.duration);
  }

  _removeScrollWarning() {
    this._container.classList.remove("leaflet-gesture-handling-scroll-warning");
  }

  _removeWarnings() {
    this._removeTouchWarning();
    this._removeScrollWarning();
  }

  // ----------------------------------------------
  // Map unload
  // ----------------------------------------------

  _handleMapUnload() {
    this.destroy();
  }

  // ----------------------------------------------
  // Destroy
  // ----------------------------------------------

  destroy() {
    if (!this._map) return;

    this.disable();

    this._map = null;
    this._container = null;
  }
}

// --------------------------------------------------
// Automatic Leaflet Map integration
// --------------------------------------------------

Map.addInitHook(function () {
  if (!this.options.gestureHandling) return;

  if (this.gestureHandling) return;

  this.gestureHandling = new GestureHandling(
    this,
    this.options.gestureHandlingOptions ?? {},
  );

  this.gestureHandling.enable();
});

// --------------------------------------------------
// Default export
// --------------------------------------------------

export default GestureHandling;
