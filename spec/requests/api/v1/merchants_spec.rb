require 'rails_helper'

RSpec.describe 'Admin::Merchants' do
  let!(:merchant) do
    create :merchant, identifier: '123456'
  end

  describe 'GET /api/v1/merchants' do
    subject(:action) { get '/api/v1/merchants', headers: headers }

    let(:headers) { {} }

    context 'when API token is valid' do
      let(:api_token) { create :api_token, :live }
      let(:headers) { { 'Authorization' => "Bearer #{api_token.token}" } }

      it { expect { action }.to change { api_token.reload.requests_count }.by(1) }

      describe 'HTTP status and response' do
        before { action }

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
    end

    context 'when API token is missing' do
      it_behaves_like 'unauthorized API request'
    end

    context 'when API token is forbidden' do
      let(:api_token) { create :api_token, enabled: false }
      let(:headers) { { 'Authorization' => "Bearer #{api_token.token}" } }

      it { expect { action }.to_not change { api_token.reload.requests_count } }

      it_behaves_like 'forbidden API request'
    end
  end

  describe 'GET /api/v1/merchant/:id' do
    subject(:action) { get "/api/v1/merchants/#{merchant.identifier}", headers: headers }

    context 'when API token is valid' do
      let(:api_token) { create :api_token, :live }
      let(:headers) { { 'Authorization' => "Bearer #{api_token.token}" } }

      it { expect { action }.to change { api_token.reload.requests_count }.by(1) }

      describe 'HTTP status and response' do
        before { action }

        it { expect(response).to have_http_status :ok }

        it 'returns a JSON:API compliant resource', :aggregate_failures do
          json = parsed_response

          expect(json.dig('data', 'id')).to eq(merchant.identifier)
          expect(json.dig('data', 'attributes', 'id')).to eq(merchant.identifier)

          expect(json['links']).to include('self')
        end
      end
    end

    context 'when API token is missing' do
      it_behaves_like 'unauthorized API request'
    end

    context 'when API token is forbidden' do
      let(:api_token) { create :api_token, enabled: false }
      let(:headers) { { 'Authorization' => "Bearer #{api_token.token}" } }

      it { expect { action }.to_not change { api_token.reload.requests_count } }

      it_behaves_like 'forbidden API request'
    end
  end
end
