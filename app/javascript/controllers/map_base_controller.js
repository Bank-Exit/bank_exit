import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";
import "leaflet-gesture-handling";
import "leaflet.fullscreen";

export default class MapBaseController extends Controller {
  static values = {
    latitude: { type: Number, default: 45.7831 },
    longitude: { type: Number, default: 3.0824 },
    zoom: { type: Number, default: 5 },
    showAttribution: { type: Boolean, default: true },
    attributionHtml: { type: String },
  };

  connect() {
    this.mapOptions = {
      attributionControl: this.showAttributionValue,
      zoomControl: false,
      gestureHandling: true,
      fullscreenControl: true,
      fullscreenControlOptions: {
        position: "topright",
        forceSeparateButton: true,
      },
      minZoom: 2,
      maxBounds: [
        [-85, -180], // Sud-Ouest
        [85, 180], // Nord-Est
      ],
      maxBoundsViscosity: 1.0,
    };
    this.markers = [];
    this.popup = L.popup({ offset: [0, -43] });
  }

  disconnect() {
    if (this.map) {
      if (this.map.gestureHandling.enabled()) {
        this.map.gestureHandling.disable();
      }
      this.map.remove();
    }
  }

  _initMap() {
    this.map = L.map(this.element, this.mapOptions);
    this.map.setView([this.latitudeValue, this.longitudeValue], this.zoomValue);

    if (
      this.showAttributionValue &&
      this.hasAttributionHtmlValue &&
      this.attributionHtmlValue !== ""
    ) {
      this.map.attributionControl.setPrefix(false);
      this.map.attributionControl.addAttribution(this.attributionHtmlValue);
    } else {
      // Need to use try/catch because embeddable
      // map with disabled attributions will break
      // on this.
      try {
        this.map.attributionControl.setPrefix(false);
        this.map.attributionControl.removeAttribution();
      } catch {}
    }

    L.control.zoom({ position: "topright" }).addTo(this.map);
    L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png").addTo(
      this.map,
    );
  }

  assignMarker(icon, extraClass = "") {
    return L.divIcon({
      html: `
        <svg width="32" height="43" viewBox="0 0 32 43" xmlns="http://www.w3.org/2000/svg">
            <path d="M16 0C7.16 0 0 7.16 0 16c0 9.9 16 27 16 27s16-17.1 16-27c0-8.84-7.16-16-16-16z" fill="currentColor"/>
            <svg x="6" y="6" width="20" height="20" class="merchant-icon">
              <use href="/map/spritesheet.svg#${icon}"/>
            </svg>
        </svg>
      `,
      className: `custom-pin-icon ${extraClass}`,
      iconSize: [32, 43],
      iconAnchor: [16, 43],
      popupAnchor: [0, -43],
    });
  }

  async loadPopupContent({ sourceTarget }) {
    const merchant = sourceTarget.options.merchant;

    this.popup = L.popup({ offset: [0, -43] });

    if (this.popup.isOpen()) {
      return false;
    }

    const response = await get(merchant.popup_path);

    if (response.ok) {
      const body = await response.html;

      this.popup
        .setLatLng(sourceTarget.getLatLng())
        .setContent(body)
        .openOn(this.map);
    }
  }
}
