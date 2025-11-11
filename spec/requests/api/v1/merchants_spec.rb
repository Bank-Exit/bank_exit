require 'swagger_helper'

RSpec.describe 'API::V1::Merchants' do
  path '/{locale}/api/v1/merchants' do
    get 'List merchants' do
      tags 'Merchants'
      produces 'application/json'
      security [bearer_auth: []]

      include_context 'with locale parameter'

      with_options in: :query do
        parameter name: :query, schema: { type: :string, default: nil }, description: 'Query matching merchant name or description'
        parameter name: :'coins[]',
                  schema: {
                    type: :array,
                    items: {
                      type: :string,
                      enum: Setting::MERCHANTS_FILTER_COINS
                    }
                  },
                  description: 'Filters results by coins'
        parameter name: :country,
                  schema: {
                    type: :string,
                    enum: ISO3166::Country.all.map(&:alpha2)
                  },
                  description: 'Filters results by country (ISO 3166-1 alpha-2 code)'
        parameter name: :continent,
                  schema: {
                    type: :string,
                    enum: I18n.t('continents').keys
                  },
                  description: 'Filters results by continent (ISO 3166-1 alpha-2 code)'
        parameter name: :with_comments,
                  schema: {
                    type: :boolean,
                    nullable: true,
                    enum: [true, false]
                  },
                  description: 'Boolean to include related comments'
      end

      include_context 'with pagination parameter'

      # variables are mandatory for parameters to make
      # RSpec pass the test :'(
      let(:query) { nil }
      let(:'coins[]') { [] } # rubocop:disable RSpec/VariableName
      let(:country) { nil }
      let(:continent) { nil }
      let(:with_comments) { false }

      before do
        create_list :merchant, 3
      end

      response 200, 'successful' do
        include_context 'with authenticated token'

        schema '$ref' => '#/components/schemas/merchants_index_response'

        run_test! do
          json = parsed_response

          expect(json).to include(:data, :meta, :links)
          expect(json['data']).to be_an(Array)
          expect(json['data'].size).to eq(3)

          merchant = json['data'].first
          expect(merchant).to include('id', 'type', 'attributes')
          expect(merchant['type']).to eq('merchants')
          expect(merchant['attributes']).to include(:id)

          expect(json['meta']).to include('current_page', 'items_count', 'total_pages', 'per_page')
          expect(json['links']).to include('first', 'last', 'prev', 'next')
        end
      end

      response 401, 'unauthorized token' do
        schema '$ref' => '#/components/schemas/unauthorized'

        include_context 'with missing token'
        it_behaves_like 'unauthorized API request'
      end

      response 403, 'forbidden token' do
        schema '$ref' => '#/components/schemas/forbidden'

        include_context 'with forbidden token'
        it_behaves_like 'forbidden API request'
      end
    end
  end

  path '/{locale}/api/v1/merchants/{id}' do
    get 'Show a merchant' do
      tags 'Merchants'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      include_context 'with locale parameter'
      parameter name: :id, in: :path, type: :string, required: true

      let!(:merchant) { create :merchant }
      let(:id) { merchant.identifier }

      response 200, 'Found merchant' do
        include_context 'with authenticated token'

        schema '$ref' => '#/components/schemas/merchant_show_response'

        run_test! do |response|
          json = parsed_response

          expect(response).to have_http_status :ok

          expect(json.dig('data', 'id')).to eq(merchant.identifier)
          expect(json.dig('data', 'attributes', 'id')).to eq(merchant.identifier)

          expect(json['links']).to include('self')
        end
      end

      response 401, 'Unauthorized token' do
        schema '$ref' => '#/components/schemas/unauthorized'

        include_context 'with missing token'
        it_behaves_like 'unauthorized API request'
      end

      response 403, 'Forbidden token' do
        schema '$ref' => '#/components/schemas/forbidden'

        include_context 'with forbidden token'
        it_behaves_like 'forbidden API request'
      end

      response 404, 'Not Found merchant' do
        schema '$ref' => '#/components/schemas/not_found'

        include_context 'with authenticated token'

        let(:id) { 'nonexistent-id' }

        run_test! do |response|
          expect(response).to have_http_status :not_found
          expect(parsed_response['errors'].first['status']).to eq('404')
        end
      end
    end
  end
end
