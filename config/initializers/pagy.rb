require 'pagy/extras/array'
require 'pagy/extras/i18n'
require 'pagy/extras/overflow'
require 'pagy/extras/pagy'

Pagy::DEFAULT[:limit] = 15
Pagy::DEFAULT[:overflow] = :last_page
