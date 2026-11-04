import MapBaseController from "controllers/map_base_controller";
import { Marker, Polyline } from "leaflet";
import "leaflet/polyline_encoded";

export default class MapItineraryController extends MapBaseController {
  static values = {
    merchant: { type: Object },
    marker: { type: String },

    geometry: { type: String },
    legs: { type: Array },
    myLat: { type: Number },
    myLon: { type: Number },
    detailedSteps: { type: Boolean, default: false },

    strokeColor: { type: String, default: "var(--map-road-color)" },
    strokeColorHighlight: { type: String, default: "var(--color-primary)" },
    strokeWidth: { type: Number, default: 4 },
    strokeWidthHighlight: { type: Number, default: 6 },
  };

  connect() {
    super.connect();
    super._initMap();

    this.routings = [];
    this.polylineConfig = {
      weight: 4,
      color: this.strokeColorValue,
      opacity: 0.7,
      lineJoin: "round",
    };

    const homeMarker = new Marker([this.myLatValue, this.myLonValue], {
      icon: this.assignMarker("home", "home-icon"),
      title: "Départ",
    });
    homeMarker.addTo(this.map);

    this.marker = new Marker(
      [this.merchantValue.latitude, this.merchantValue.longitude],
      {
        icon: this.assignMarker(this.merchantValue.icon),
        merchant: this.merchantValue,
      },
    );

    this.marker.on("click", this.loadPopupContent.bind(this));
    this.marker.addTo(this.map);

    // this.marker.fire("click");

    let routing;

    if (this.detailedStepsValue) {
      this.legsValue.forEach((leg) => {
        leg.steps.forEach((step, index) => {
          const routing = Polyline.fromEncoded(step.geometry, {
            ...this.polylineConfig,
            className: `step_${index} motion-safe:transition-colors`,
          });

          routing.addTo(this.map);

          this.routings.push({
            stepIndex: `step_${index}`,
            routing: routing,
          });
        });
      });

      routing = Polyline.fromEncoded(this.geometryValue);
    } else {
      routing = Polyline.fromEncoded(this.geometryValue, this.polylineConfig);

      routing.addTo(this.map);
    }

    this.map.fitBounds(routing.getBounds());
  }

  highlightRoad({ detail: { stepIndex } }) {
    const $path = document.querySelector(`svg path.${stepIndex}`);

    $path.setAttribute("stroke", this.strokeColorHighlightValue);
    $path.setAttribute("stroke-width", this.strokeWidthHighlightValue);
  }

  unhighlightRoad({ detail: { stepIndex } }) {
    const $path = document.querySelector(`svg path.${stepIndex}`);

    $path.setAttribute("stroke", this.strokeColorValue);
    $path.setAttribute("stroke-width", this.strokeWidthValue);
  }

  zoomRoad({ detail: { stepIndex } }) {
    // const $path = document.querySelector(`svg path.${stepIndex}`);

    const item = this.routings.find((routing) => {
      return routing.stepIndex === stepIndex;
    });
    this.map.fitBounds(item.routing.getBounds());
  }
}
