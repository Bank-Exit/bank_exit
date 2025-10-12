require 'pagy/extras/array'
require 'pagy/extras/i18n'
require 'pagy/extras/overflow'
require 'pagy/extras/pagy'
require 'pagy/extras/jsonapi'

Pagy::DEFAULT[:limit] = 15
Pagy::DEFAULT[:overflow] = :last_page
Pagy::DEFAULT[:jsonapi] = false
