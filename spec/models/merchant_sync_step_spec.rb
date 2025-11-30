require 'rails_helper'

RSpec.describe MerchantSyncStep do
  describe '[status]' do
    context 'when merchant_sync is error' do
      let(:merchant_sync) { create :merchant_sync, :error }

      context 'when all steps are marked as success' do
        before do
          create :merchant_sync_step, :init, :success, merchant_sync: merchant_sync
          create :merchant_sync_step, :overpass_api, :success, merchant_sync: merchant_sync
          create :merchant_sync_step, :save_data, :success, merchant_sync: merchant_sync

          country_step = create :merchant_sync_step, :assign_country, :error, merchant_sync: merchant_sync
          country_step.update(status: :success)
        end

        it { expect(merchant_sync).to be_success }
      end

      context 'when at least one step is marked as failure' do
        before do
          create :merchant_sync_step, :init, :success, merchant_sync: merchant_sync
          create :merchant_sync_step, :overpass_api, :success, merchant_sync: merchant_sync
          create :merchant_sync_step, :save_data, :success, merchant_sync: merchant_sync

          country_step = create :merchant_sync_step, :assign_country, :pending, merchant_sync: merchant_sync
          country_step.update(status: :error)
        end

        it { expect(merchant_sync).to be_error }
      end
    end
  end
end
