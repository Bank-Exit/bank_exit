RSpec.shared_context 'with locale parameter' do
  let(:locale) { nil }

  parameter name: :locale,
            in: :path,
            required: true,
            schema: {
              type: :string,
              default: I18n.default_locale,
              enum: I18n.available_locales
            },
            description: 'Locale used for the response language, must be one of the supported locales.'
end

RSpec.shared_context 'with pagination parameter' do
  let(:page) { 1 }
  let(:per) { 12 }

  with_options in: :query do
    parameter name: :page,
              required: false,
              schema: {
                type: :integer,
                default: 1
              },
              description: 'Page number'
    parameter name: :per,
              required: false,
              schema: {
                type: :integer,
                default: Pagy::DEFAULT[:limit]
              },
              description: 'Per page value'
  end
end
