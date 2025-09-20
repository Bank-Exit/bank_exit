require 'rails_helper'

RSpec.describe 'Merchants::Popups' do
  let(:merchant) { create :merchant }
  let(:invalid_merchant_id) { 'fakeID' }

  describe 'GET /merchants/:id/popup' do
    subject! { get "/merchants/#{merchant.identifier}/popup" }

    it { expect(response).to have_http_status :redirect }
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/merchants/:id/popup" do
      context 'when merchant exists' do
        subject! { get "/#{locale}/merchants/#{merchant.identifier}/popup" }

        it { expect(response).to have_http_status :ok }
      end

      context 'when merchant does not exist' do
        subject! { get "/#{locale}/merchants/#{invalid_merchant_id}/popup" }

        it { expect(response).to have_http_status :not_found }
      end
    end
  end
end
