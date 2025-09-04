require 'rails_helper'

RSpec.describe 'Maps' do
  before { create_list :merchant, 3 }

  describe 'GET /map' do
    context 'without search options' do
      subject! { get '/map' }

      it { is_expected.to redirect_to pretty_map_en_path(zoom: 5, lat: 45.7831, lon: 3.0824) }
    end

    context 'with search options' do
      subject! { get '/map?country=IT' }

      it { is_expected.to redirect_to pretty_map_en_path(zoom: 5, lat: 45.7831, lon: 3.0824, country: 'IT') }
    end
  end

  describe 'GET /map/:zoom' do
    subject! { get '/map/8' }

    it { is_expected.to redirect_to pretty_map_en_path(zoom: 8, lat: 45.7831, lon: 3.0824) }
  end

  describe 'GET /map/:zoom/:lat' do
    subject! { get '/map/8/1234' }

    it { is_expected.to redirect_to pretty_map_en_path(zoom: 8, lat: 1234, lon: 3.0824) }
  end

  describe 'GET /map/:zoom/:lat/:lon' do
    context 'without search options' do
      subject! { get '/map/6/123.45/-678.90' }

      it { expect(response).to have_http_status :ok }
    end

    context 'with search options' do
      subject! do
        get '/map/6/123.45/-678.90',
            params: { map: {
              search: 'bar', category: 'fast_food',
              coins: %w[bitcoin monero]
            } }
      end

      it { expect(response).to have_http_status :ok }
    end

    %i[map table grid].each do |display|
      context "when display mode is #{display}" do
        subject! do
          get '/map/6/123.45/-678.90',
              params: { display: display }
        end

        it { expect(response).to have_http_status :ok }
      end
    end
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/map" do
      context 'without search options' do
        subject! { get "/#{locale}/map" }

        it { is_expected.to redirect_to send("pretty_map_#{locale}_path", zoom: 5, lat: 45.7831, lon: 3.0824) }
      end

      context 'with search options' do
        subject! { get "/#{locale}/map?country=IT" }

        it { is_expected.to redirect_to send("pretty_map_#{locale}_path", zoom: 5, lat: 45.7831, lon: 3.0824, country: 'IT') }
      end
    end

    describe "GET /#{locale}/map/:zoom" do
      subject! { get "/#{locale}/map/8" }

      it { is_expected.to redirect_to send("pretty_map_#{locale}_path", zoom: 8, lat: 45.7831, lon: 3.0824) }
    end

    describe "GET /#{locale}/map/:zoom/:lat" do
      subject! { get "/#{locale}/map/8/1234" }

      it { is_expected.to redirect_to send("pretty_map_#{locale}_path", zoom: 8, lat: 1234, lon: 3.0824) }
    end

    describe "GET /#{locale}/map/:zoom/:lat/:lon" do
      context 'without search options' do
        subject! { get "/#{locale}/map/6/123.45/-678.90" }

        it { expect(response).to have_http_status :ok }
      end

      context 'with search options' do
        subject! do
          get "/#{locale}/map/6/123.45/-678.90",
              params: { map: {
                search: 'bar', category: 'fast_food',
                coins: %w[bitcoin monero]
              } }
        end

        it { expect(response).to have_http_status :ok }
      end
    end
  end

  describe 'GET /map/merchants' do
    subject(:action) { get '/map/merchants.gpx', params: params }

    let(:params) do
      {
        coins: ['Monero'],
        category: 'restaurant',
        country: 'FR'
      }
    end

    before do
      create :merchant, :with_latlon, name: 'Merchant One', category: 'restaurant', country: 'FR', coins: %i[monero bitcoin]
      create :merchant, :with_latlon, name: 'Merchant Two', category: 'restaurant', country: 'FR', coins: %i[monero]
      create :merchant, :with_latlon, name: 'Merchant Three', category: 'cafe', country: 'FR', coins: %i[monero]
      create :merchant, :with_latlon, name: 'Merchant Italy', country: 'IT', coins: %i[monero bitcoin june]

      travel_to Date.new(2025, 8, 31)
      action
    end

    describe '[metadata]' do
      it 'has correct metadata', :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/gpx+xml')
        expect(response.headers['Content-Disposition']).to match(/attachment; filename=.*\.gpx/)
      end

      it 'has correct document filename' do
        expect(response.headers['Content-Disposition']).to match('merchants_monero_restaurant_fr_2025-08-31')
      end

      it { expect(response.body).to include('<name>Merchants - Monero - Restaurant - 🇫🇷 France - 2025-08-31 🚀</name>') }
    end

    it 'includes expected merchants in the GPX output', :aggregate_failures do
      expect(response.body).to include('Merchant One')
      expect(response.body).to include('Merchant Two')
    end

    it 'includes GPX root element' do
      expect(response.body).to include('<gpx')
    end

    it 'includes waypoints for each merchant' do
      expect(response.body.scan('<wpt').size).to eq(2)
    end
  end
end
