# Pin npm packages by running ./bin/importmap

pin 'application', preload: :application
pin 'map_embed', preload: :map_embed

pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'

pin_all_from 'app/javascript/controllers', under: 'controllers', preload: :application

pin '@rails/request.js', to: 'https://ga.jspm.io/npm:@rails/request.js@0.0.12/src/index.js'

pin 'stimulus-use', to: 'https://ga.jspm.io/npm:stimulus-use@0.52.3/dist/index.js', preload: :application
pin 'stimulus-use/hotkeys', to: 'stimulus-use--hotkeys.js', preload: :application # @0.52.3
pin 'hotkeys-js' # @3.13.15

pin 'leaflet', to: 'https://ga.jspm.io/npm:leaflet@1.9.4/dist/leaflet-src.js'
pin 'leaflet-gesture-handling', to: 'https://ga.jspm.io/npm:leaflet-gesture-handling@1.2.2/dist/leaflet-gesture-handling.min.js'
pin 'leaflet.markercluster', to: 'https://ga.jspm.io/npm:leaflet.markercluster@1.5.3/dist/leaflet.markercluster-src.js'
pin 'leaflet.fullscreen', to: 'https://unpkg.com/leaflet.fullscreen@4.0.0/Control.FullScreen.js'
pin 'polyline-encoded', preload: :application # @0.0.9

pin 'turbo_power', preload: :application # @0.7.1
pin 'autocomplete', to: 'autocomplete.esm.min.js', preload: :application # @2.0.3

pin 'chartkick', to: 'chartkick.js', preload: :application
pin 'Chart.bundle', to: 'Chart.bundle.js', preload: :application

pin 'sortablejs', to: 'https://ga.jspm.io/npm:sortablejs@1.15.6/modular/sortable.core.esm.js'
