# Pin npm packages by running ./bin/importmap

pin 'application', preload: :application
pin 'map_embed', preload: :map_embed

pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'

pin_all_from 'app/javascript/controllers', under: 'controllers', preload: :application

pin '@rails/request.js', to: 'https://ga.jspm.io/npm:@rails/request.js@0.0.13/src/index.js'

pin 'stimulus-use', to: 'https://ga.jspm.io/npm:stimulus-use@0.53.0/dist/index.js', preload: :application

pin 'leaflet', to: 'https://cdn.jsdelivr.net/npm/leaflet@2.0.0-beta.2/dist/leaflet.js'
pin 'leaflet.markercluster', to: 'https://cdn.jsdelivr.net/npm/leaflet.markercluster@2.0.0-beta.1/dist/leaflet.markercluster.js'
pin 'leaflet/gesture_handling'
pin 'leaflet/fullscreen'
pin 'leaflet/polyline_encoded', preload: :application

pin 'chartkick', to: 'chartkick.js', preload: :application
pin 'Chart.bundle', to: 'Chart.bundle.js', preload: :application

pin 'sortablejs', to: 'https://ga.jspm.io/npm:sortablejs@1.15.7/modular/sortable.core.esm.js', preload: :application
pin 'mermaid', to: 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs', preload: :application
