import MapBaseController from "controllers/map_base_controller";
import "leaflet.markercluster";
import { get, patch } from "@rails/request.js";
import { useIntersection } from "stimulus-use";

export default class MapController extends MapBaseController {
  static targets = ["loader"];
  static values = {
    trackGeolocationInUrl: { type: Boolean, default: true },
    fitBounds: { type: Boolean, default: false },
    fetchMarkersUrl: String,
    refererUrl: String,
  };

  connect() {
    const [_, unobserve] = useIntersection(this);
    this.unobserve = unobserve;
    this.bounds;
    this.#showLoader();

    window.addEventListener("popstate", this.handlePopState.bind(this));
  }

  async appear() {
    super.connect();

    this.mapOptions["gestureHandling"] = this.#forceGestureHandling();

    super._initMap();
    this.unobserve();

    const currentParams = new URLSearchParams(window.location.search);
    const urlWithParams = `${this.fetchMarkersUrlValue}?${currentParams.toString()}`;

    try {
      const response = await get(urlWithParams, {
        responseKind: "json",
      });

      if (!response.ok) throw new Error("Error while fetching markers");

      const body = await response.json;

      this.bitcoinMarkers = L.markerClusterGroup({
        spiderfyOnMaxZoom: true,
        showCoverageOnHover: false,
        zoomToBoundsOnClick: true,
        chunkedLoading: true,
      });

      this.otherMarkers = L.markerClusterGroup({
        spiderfyOnMaxZoom: true,
        showCoverageOnHover: false,
        zoomToBoundsOnClick: true,
        maxClusterRadius: 40,
      });

      body.forEach((data) => {
        const marker = L.marker([data.latitude, data.longitude], {
          icon: this.assignMarker(data.icon),
          merchant: data,
        });

        marker.on("click", this.loadPopupContent.bind(this));

        if (this.#isBitcoinOnly(data)) {
          this.bitcoinMarkers.addLayer(marker);
        } else {
          this.otherMarkers.addLayer(marker);
        }
      });

      this.map.addLayer(this.bitcoinMarkers);
      this.map.addLayer(this.otherMarkers);

      this.bounds = L.latLngBounds(this.bitcoinMarkers.getBounds());
      this.bounds.extend(this.otherMarkers.getBounds());
      if (this.#forceFitBounds()) {
        if (this.bounds.isValid()) {
          this.map.fitBounds(this.bounds, { maxZoom: 14 });
        }
      }

      this.#hideLoader();
    } catch (error) {
      console.error("Failed to load map data:", error);
      this.#hideLoader();
    }

    if (this.trackGeolocationInUrlValue) {
      this.map.on("zoomend", (_) => {
        const newZoom = this.map.getZoom();
        let current = new URL(window.location.href);

        const newPathname = this.#buildNewPathnameForZoom(current, newZoom);

        if (newPathname !== undefined) {
          current.pathname = newPathname;
          window.history.replaceState(null, "", current);

          // Update merchants filter form action
          document.getElementById("merchants_filter").action = current.pathname;

          this.#updateReferUrl(current.href);
        }
      });

      this.map.on("moveend", (e) => {
        const coordinates = e.target.getBounds().getCenter();
        let current = new URL(window.location.href);

        const newPathname = this.#buildNewPathnameForLatlon(
          current,
          coordinates.lat,
          coordinates.lng,
        );

        if (newPathname !== undefined) {
          current.pathname = newPathname;
          window.history.replaceState(null, "", current);

          // Update merchants filter form action
          document.getElementById("merchants_filter").action = current.pathname;

          this.#updateReferUrl(current.href);
        }
      });
    }
  }

  #showLoader() {
    if (this.hasLoaderTarget) {
      this.loaderTarget.classList.remove("hidden");
    }
  }

  #hideLoader() {
    if (this.hasLoaderTarget) {
      this.loaderTarget.classList.add("hidden");
    }
  }

  disconnect() {
    if (this.bitcoinMarkers) {
      this.bitcoinMarkers.clearLayers();
    }
    if (this.otherMarkers) {
      this.otherMarkers.clearLayers();
    }

    window.removeEventListener("popstate", this.handlePopState.bind(this));

    super.disconnect();
  }

  toggleFitBounds({ detail: { checked } }) {
    if (checked && this.bounds.isValid()) {
      this.map.fitBounds(this.bounds, { maxZoom: 14 });
    }
  }

  toggleGestureHandling(_e) {
    if (this.map.gestureHandling.enabled()) {
      this.map.gestureHandling.disable();
    } else {
      this.map.gestureHandling.enable();
    }
  }

  #buildNewPathnameForZoom(current, newZoom) {
    const pathSplit = current.pathname.split("/");

    // No locale present
    if (pathSplit.length == 5) {
      let [_, action, _oldZoom, latitude, longitude] = pathSplit;

      return [action, newZoom, latitude, longitude].join("/");
    }
    // Locale present
    else if (pathSplit.length == 6) {
      let [_, locale, action, oldZoom, latitude, longitude] = pathSplit;

      return [locale, action, newZoom, latitude, longitude].join("/");
    }
  }

  #buildNewPathnameForLatlon(current, newLatitude, newLongitude) {
    const pathSplit = current.pathname.split("/");

    // No locale present
    if (pathSplit.length == 5) {
      let [_, action, zoom, _oldLatitude, _oldLongitude] = pathSplit;

      return [action, zoom, newLatitude, newLongitude].join("/");
    }
    // Locale present
    else if (pathSplit.length == 6) {
      let [_, locale, action, zoom, _oldLatitude, _oldLongitude] = pathSplit;

      return [locale, action, zoom, newLatitude, newLongitude].join("/");
    }
  }

  #updateReferUrl(value) {
    patch(this.refererUrlValue, {
      body: {
        map_referer_url: value,
      },
    });
  }

  #isBitcoinOnly(item) {
    if (item.coins.includes("monero") || item.coins.includes("june")) {
      return false;
    }

    return true;
  }

  #forceFitBounds() {
    return (
      this.fitBoundsValue || localStorage.getItem("force-fit-bounds") == "true"
    );
  }

  #forceGestureHandling() {
    return localStorage.getItem("force-gesture-handling") == "true";
  }

  handlePopState(_e) {
    Turbo.visit(window.location.href);
  }
}
