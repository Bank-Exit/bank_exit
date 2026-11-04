import { Polyline, Polygon } from "leaflet";

// --------------------------------------------------
// Polyline encoded utilities
// Google Encoded Polyline Algorithm
// --------------------------------------------------

const DEFAULT_PRECISION = 5;

// --------------------------------------------------
// Encode helpers
// --------------------------------------------------

function encodeSignedNumber(value) {
  let sgnNum = value << 1;

  if (value < 0) {
    sgnNum = ~sgnNum;
  }

  let encoded = "";

  while (sgnNum >= 0x20) {
    encoded += String.fromCharCode((0x20 | (sgnNum & 0x1f)) + 63);

    sgnNum >>= 5;
  }

  encoded += String.fromCharCode(sgnNum + 63);

  return encoded;
}

function getCoordinates(point) {
  if (Array.isArray(point)) {
    return [Number(point[0]), Number(point[1])];
  }

  if (point && typeof point === "object") {
    if ("lat" in point && "lng" in point) {
      return [Number(point.lat), Number(point.lng)];
    }
  }

  throw new TypeError("Invalid coordinate: expected [lat, lng] or LatLng");
}

// --------------------------------------------------
// PolylineUtil
// --------------------------------------------------

export const PolylineUtil = {
  // ----------------------------------------------
  // Encode
  // ----------------------------------------------

  encode(latlngs, precision = DEFAULT_PRECISION) {
    if (!Array.isArray(latlngs)) {
      throw new TypeError("latlngs must be an array");
    }

    const factor = Math.pow(10, precision);

    let previousLat = 0;
    let previousLng = 0;

    let encoded = "";

    for (const point of latlngs) {
      const [lat, lng] = getCoordinates(point);

      const currentLat = Math.round(lat * factor);
      const currentLng = Math.round(lng * factor);

      const deltaLat = currentLat - previousLat;
      const deltaLng = currentLng - previousLng;

      encoded += encodeSignedNumber(deltaLat);
      encoded += encodeSignedNumber(deltaLng);

      previousLat = currentLat;
      previousLng = currentLng;
    }

    return encoded;
  },

  // ----------------------------------------------
  // Decode
  // ----------------------------------------------

  decode(encoded, precision = DEFAULT_PRECISION) {
    if (typeof encoded !== "string") {
      throw new TypeError("encoded must be a string");
    }

    if (!Number.isInteger(precision) || precision < 0 || precision > 7) {
      throw new RangeError("precision must be an integer between 0 and 7");
    }

    const factor = Math.pow(10, -precision);

    const latlngs = [];

    let index = 0;
    let lat = 0;
    let lng = 0;

    function decodeValue() {
      let result = 0;
      let shift = 0;
      let byte;

      do {
        if (index >= encoded.length) {
          throw new Error("Invalid encoded polyline: incomplete sequence");
        }

        byte = encoded.charCodeAt(index++) - 63;

        if (byte < 0 || byte > 63) {
          throw new Error("Invalid encoded polyline character");
        }

        result |= (byte & 0x1f) << shift;

        shift += 5;

        if (shift > 30) {
          throw new Error("Invalid encoded polyline: value overflow");
        }
      } while (byte >= 0x20);

      return result & 1 ? ~(result >> 1) : result >> 1;
    }

    while (index < encoded.length) {
      lat += decodeValue();
      lng += decodeValue();

      latlngs.push([lat * factor, lng * factor]);
    }

    return latlngs;
  },
};

// --------------------------------------------------
// Polyline extensions
// --------------------------------------------------

// Create a Polyline directly from an encoded string.
Polyline.fromEncoded = function (
  encoded,
  options = {},
  precision = DEFAULT_PRECISION,
) {
  return new Polyline(PolylineUtil.decode(encoded, precision), options);
};

// Encode an existing Polyline.
Polyline.prototype.encodePath = function (precision = DEFAULT_PRECISION) {
  return PolylineUtil.encode(this.getLatLngs(), precision);
};

// --------------------------------------------------
// Polygon extensions
// --------------------------------------------------

// Create a Polygon directly from an encoded string.
Polygon.fromEncoded = function (
  encoded,
  options = {},
  precision = DEFAULT_PRECISION,
) {
  return new Polygon(PolylineUtil.decode(encoded, precision), options);
};

// Encode an existing Polygon.
// Supports multiple rings and holes.
Polygon.prototype.encodePath = function (precision = DEFAULT_PRECISION) {
  const rings = this.getLatLngs();

  if (!Array.isArray(rings) || rings.length === 0) {
    return "";
  }

  // A Polygon normally has an array of rings.
  // Each ring must be encoded separately because
  // the algorithm uses relative coordinates.
  const encodeRing = (ring) => PolylineUtil.encode(ring, precision);

  if (
    Array.isArray(rings[0]) &&
    rings[0].length > 0 &&
    Array.isArray(rings[0][0])
  ) {
    return rings.map(encodeRing);
  }

  return encodeRing(rings);
};

// --------------------------------------------------
// Default export
// --------------------------------------------------

export default PolylineUtil;
