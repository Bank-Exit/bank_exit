require 'swagger_helper'

RSpec.describe 'Statistics API' do
  path '/{locale}/api/v1/statistics' do
    get 'Fetch statistics' do
      tags 'Statistics'
      produces 'application/json'
      security [bearer_auth: []]

      include_context 'with locale parameter'

      with_options in: :query do
        parameter name: :atms,
                  schema: {
                    type: :boolean,
                    default: nil
                  },
                  description: 'Include ATMs in statistics'
      end

      before do
        create :merchant_sync, :success
        create :merchant, :bitcoin
        create :merchant, :monero
        create :merchant, :june, category: :restaurant
      end

      let(:atms) { nil }

      response 200, 'Found statistics' do
        include_context 'with authenticated token'

        schema '$ref' => '#/components/schemas/statistics'

        run_test!
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
end
