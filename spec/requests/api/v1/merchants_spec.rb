require 'rails_helper'

RSpec.describe 'Admin::Merchants' do
  let!(:merchant) do
    create :merchant, identifier: '123456'
  end

  describe 'GET /api/v1/merchants' do
    subject! { get '/api/v1/merchants' }

    it { expect(response).to have_http_status :ok }

    it 'returns a JSON:API compliant list', :aggregate_failures do
      json = parsed_response

      expect(json).to include(:data, :meta, :links)
      expect(json['data']).to be_an(Array)
      expect(json['data'].size).to eq(1)

      merchant = json['data'].first
      expect(merchant).to include('id', 'type', 'attributes')
      expect(merchant['type']).to eq('merchants')
      expect(merchant['attributes']).to include(id: '123456')

      expect(json['meta']).to include('page', 'count', 'pages', 'size')
      expect(json['links']).to include('first', 'last', 'prev', 'next')
    end
  end

  describe 'GET /api/v1/merchant/:id' do
    subject! { get "/api/v1/merchants/#{merchant.identifier}" }

    it { expect(response).to have_http_status :ok }

    it 'returns a JSON:API compliant resource', :aggregate_failures do
      json = parsed_response

      expect(json.dig('data', 'id')).to eq(merchant.identifier)
      expect(json.dig('data', 'attributes', 'id')).to eq(merchant.identifier)

      expect(json['links']).to include('self')
    end
  end
end
