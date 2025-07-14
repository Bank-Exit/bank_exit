require 'rails_helper'

RSpec.describe 'Merchants' do
  let(:merchant) do
    create :merchant, :with_address, :with_opening_hours, :with_geometry_polygon, :with_all_contacts
  end
  let(:invalid_merchant_id) { 'fakeID' }

  describe 'GET /merchants/:id' do
    context 'when merchant exists' do
      subject(:action) { get "/merchants/#{merchant.identifier}" }

      before do
        create_list :comment, 3, commentable: merchant
        create :comment, :flagged

        action
      end

      it { expect(response).to have_http_status :ok }
    end

    context 'when merchant does not exist' do
      subject! { get "/merchants/#{invalid_merchant_id}" }

      it { expect(response).to have_http_status :moved_permanently }
      it { expect(response).to redirect_to maps_en_path }
    end

    describe 'when logo and banner are attached' do
      subject! { get "/merchants/#{merchant.identifier}" }

      let(:merchant) do
        create :merchant, :with_address, :with_opening_hours, :with_geometry_polygon, :with_all_contacts, :with_logo, :with_banner
      end

      it { expect(response).to have_http_status :ok }
    end

    describe '[pre-deleted]' do
      before do
        merchant.update(deleted_at: 1.hour.ago)
      end

      context 'when debug flag is true' do
        subject! do
          get "/merchants/#{merchant.identifier}", params: { debug: 'true' }
        end

        it { expect(response).to have_http_status :ok }
      end

      context 'when debug flag is missing' do
        subject! { get "/merchants/#{merchant.identifier}" }

        it { expect(response).to have_http_status :found }
        it { expect(response).to redirect_to maps_en_path }
        it { expect(flash[:alert]).to eq I18n.t('merchants.show.alert', locale: :en) }
      end
    end
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/merchants/:id" do
      context 'when merchant exists' do
        subject(:action) { get "/#{locale}/merchants/#{merchant.identifier}" }

        before do
          create_list :comment, 3, commentable: merchant
          create :comment, :flagged

          action
        end

        it { expect(response).to have_http_status :ok }
      end

      context 'when merchant does not exist' do
        subject! { get "/#{locale}/merchants/#{invalid_merchant_id}" }

        it { expect(response).to have_http_status :moved_permanently }
        it { expect(response).to redirect_to send("maps_#{locale}_path") }
      end

      describe '[pre-deleted]' do
        before do
          merchant.update(deleted_at: 1.hour.ago)
        end

        context 'when debug flag is true' do
          subject! do
            get "/#{locale}/merchants/#{merchant.identifier}", params: { debug: 'true' }
          end

          it { expect(response).to have_http_status :ok }
        end

        context 'when debug flag is missing' do
          subject! { get "/#{locale}/merchants/#{merchant.identifier}" }

          it { expect(response).to have_http_status :found }
          it { expect(response).to redirect_to send("maps_#{locale}_path") }
        end
      end
    end
  end

  describe 'GET /merchants/refresh.turbo_stream' do
    subject(:action) { post '/merchants/refresh', as: :turbo_stream }

    before { stub_overpass_request_success }

    it { expect { action }.to have_enqueued_job(CallableJob).with('FetchMerchants') }

    describe '[HTTP status]' do
      before { action }

      it { expect(response).to have_http_status :ok }
      it { expect(flash[:notice]).to eq I18n.t('merchants.refresh.notice') }
    end
  end
end
