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
end
