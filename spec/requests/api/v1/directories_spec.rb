require 'swagger_helper'

RSpec.describe 'API::V1::Directories' do
  path '/{locale}/api/v1/directories' do
    get 'List directories' do
      tags 'Directories'
      produces 'application/json'
      security [bearer_auth: []]

      include_context 'with locale parameter'

      with_options in: :query do
        parameter name: :query, schema: { type: :string, default: nil }, description: 'Filters results by name or description'
        parameter name: :'coins[]',
                  schema: {
                    type: :array,
                    default: nil,
                    items: {
                      type: :string,
                      enum: Setting::MERCHANTS_FILTER_COINS
                    }
                  },
                  description: 'Filters results by coins'
        parameter name: :city,
                  schema: {
                    type: :string
                  },
                  description: 'Filters results by delivery zone city'
        parameter name: :department,
                  schema: {
                    type: :string,
                    enum: I18n.t('departments').keys
                  },
                  description: 'Filters results by delivery zone French departments'
        parameter name: :country,
                  schema: {
                    type: :string,
                    enum: ISO3166::Country.all.map(&:alpha2)
                  },
                  description: 'Filters results by delivery zone country (ISO 3166-1 alpha-2 code)'
        parameter name: :continent,
                  schema: {
                    type: :string,
                    enum: I18n.t('continents').keys
                  },
                  description: 'Filters results by delivery zone continent (ISO 3166-1 alpha-2 code)'
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
      let(:city) { nil }
      let(:department) { nil }
      let(:country) { nil }
      let(:continent) { nil }
      let(:with_comments) { false }

      before do
        create_list :directory, 3
      end

      response 200, 'Found directories' do
        include_context 'with authenticated token'

        schema '$ref' => '#/components/schemas/directories_index_response'

        run_test! do
          json = parsed_response

          expect(json).to include(:data, :meta, :links)
          expect(json['data']).to be_an(Array)
          expect(json['data'].size).to eq(3)

          directory = json['data'].first
          expect(directory).to include('id', 'type', 'attributes')
          expect(directory['type']).to eq('directories')
          expect(directory['attributes']).to include(:id)

          expect(json['meta']).to include('current_page', 'items_count', 'total_pages', 'per_page')
          expect(json['links']).to include('first', 'last', 'prev', 'next')
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
    end
  end

  path '/{locale}/api/v1/directories/{id}' do
    get 'Show a directory' do
      tags 'Directories'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      include_context 'with locale parameter'
      parameter name: :id, in: :path, type: :string, required: true

      let!(:directory) { create :directory }
      let(:id) { directory.id }

      response 200, 'Found directory' do
        include_context 'with authenticated token'

        schema '$ref' => '#/components/schemas/directory_show_response'

        run_test! do |response|
          json = parsed_response

          expect(response).to have_http_status :ok

          expect(json.dig('data', 'id')).to eq(directory.id)
          expect(json.dig('data', 'attributes', 'id')).to eq(directory.id)

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

      response 404, 'Not Found directory' do
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
