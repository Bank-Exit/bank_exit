import MapBaseController from "controllers/map_base_controller";
import "leaflet.markercluster";
import { get } from "@rails/request.js";

export default class MapEmbedController extends MapBaseController {
  static targets = ["loader"];
  static values = {
    fetchMarkersUrl: String,
    gestureHandling: { type: Boolean, default: true },
    fitBounds: { type: Boolean, default: true },
    useClusters: { type: Boolean, default: true },
  };

  async connect() {
    this.#showLoader();
    super.connect();

    this.mapOptions["gestureHandling"] = this.gestureHandlingValue;

    super._initMap();

    if (this.useClustersValue) {
      this.markers = L.markerClusterGroup({
        spiderfyOnMaxZoom: true,
        showCoverageOnHover: false,
        zoomToBoundsOnClick: true,
        chunkedLoading: true,
      });
    } else {
      this.markers = L.featureGroup();
    }

    try {
      const currentParams = new URLSearchParams(window.location.search);
      const urlWithParams = `${this.fetchMarkersUrlValue}?${currentParams.toString()}`;
      const response = await get(urlWithParams, {
        responseKind: "json",
      });

      if (!response.ok) throw new Error("Error while fetching markers");

      const body = await response.json;

      body.forEach((data) => {
        const marker = L.marker([data.latitude, data.longitude], {
          icon: this.assignMarker(data.icon),
          merchant: data,
        });

        marker.on("click", this.loadPopupContent.bind(this));

        this.markers.addLayer(marker);
      });

      if (this.showAttributionValue) {
        this.map.attributionControl.addAttribution(`${body.length} 📍`);
      }

      this.map.addLayer(this.markers);

      if (this.fitBoundsValue) {
        this.map.fitBounds(this.markers.getBounds(), {
          maxZoom: 15,
        });
      }

      this.#hideLoader();
    } catch (error) {
      console.error("Failed to load map data:", error);
      this.#hideLoader();
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
    this.markers.clearLayers();

    super.disconnect();
  }
}
