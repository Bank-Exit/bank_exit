require 'rails_helper'

def coin_ids
  @coin_ids ||= Coin.all.map(&:identifier)
end

RSpec.describe 'Coins' do
  let(:invalid_coin_id) { 'shitcoin' }

  describe 'GET /coins/:id' do
    coin_ids.each do |coin|
      context "when #{coin}" do
        subject! { get "/coins/#{coin}" }

        it { expect(response).to have_http_status :redirect }
      end
    end

    context 'when coin does not exist' do
      subject! { get "/coins/#{invalid_coin_id}" }

      it { expect(response).to have_http_status :redirect }
    end
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/coins/:id" do
      coin_ids.each do |coin|
        context "when #{coin}" do
          subject! { get "/#{locale}/coins/#{coin}" }

          it { expect(response).to have_http_status :ok }
        end
      end

      context 'when coin does not exist' do
        subject! { get "/#{locale}/coins/#{invalid_coin_id}" }

        it { expect(response).to have_http_status :not_found }
      end
    end
  end
end
