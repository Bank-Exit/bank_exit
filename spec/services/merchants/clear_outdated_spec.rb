require 'rails_helper'

RSpec.describe Merchants::ClearOutdated do
  describe '#call' do
    subject(:call) { described_class.call }

    # Bitcoin
    let!(:deleted_below_delta_bitcoin) { create :merchant, :bitcoin, deleted_at: 1.day.ago }
    let!(:deleted_above_delta_bitcoin) { create :merchant, :bitcoin, deleted_at: 1.month.ago }

    # Monero
    let!(:deleted_below_delta_monero) { create :merchant, :monero, deleted_at: 1.day.ago }
    let!(:deleted_above_delta_monero) { create :merchant, :monero, deleted_at: 1.month.ago }

    # June
    let!(:deleted_below_delta_june) { create :merchant, :june, deleted_at: 1.day.ago }
    let!(:deleted_above_delta_june) { create :merchant, :june, deleted_at: 1.month.ago }

    let!(:available_merchant) { create :merchant, :monero, deleted_at: nil }

    let(:merchant_sync) { MerchantSync.last }
    let(:fetch_step) { merchant_sync.merchant_sync_steps.fetch_outdated.first }
    let(:clear_step) { merchant_sync.merchant_sync_steps.clear_outdated.first }

    it { expect { call }.to change { Merchant.count }.by(-1) }

    context 'when merchant is available' do
      before { call }

      it { expect { available_merchant.reload }.to_not raise_error }
      it { expect(merchant_sync.status).to eq 'success' }
      it { expect(fetch_step.status).to eq 'success' }
      it { expect(clear_step.status).to eq 'success' }
    end

    context 'when an error is raised' do
      before do
        relation = double('relation') # rubocop:disable RSpec/VerifiedDoubles
        allow(Merchant).to receive(:deleted).and_return(relation)

        allow(relation).to receive_messages(bitcoin_only: relation, where: relation)
        allow(relation).to receive(:count) { 5 }
        allow(relation).to receive(:destroy_all).and_raise(StandardError, '#destroy_all raised it !')

        allow(relation).to receive(:map) { [] }

        call
      end

      it { expect(fetch_step.status).to eq 'success' }
      it { expect(clear_step.status).to eq 'error' }
      it { expect(merchant_sync.status).to eq 'error' }
      it { expect { call }.to_not change { Merchant.count } }
    end

    context 'when delta time is not yet exceeded' do
      before { call }

      it { expect { deleted_below_delta_bitcoin.reload }.to_not raise_error }
      it { expect { deleted_below_delta_monero.reload }.to_not raise_error }
      it { expect { deleted_below_delta_june.reload }.to_not raise_error }
      it { expect(merchant_sync.status).to eq 'success' }
      it { expect(fetch_step.status).to eq 'success' }
      it { expect(clear_step.status).to eq 'success' }
    end

    context 'when delta time is exceeded' do
      before { call }

      it { expect { deleted_above_delta_bitcoin.reload }.to raise_error(ActiveRecord::RecordNotFound) }
      it { expect { deleted_above_delta_monero.reload }.to_not raise_error }
      it { expect { deleted_above_delta_june.reload }.to_not raise_error }
      it { expect(merchant_sync.status).to eq 'success' }
      it { expect(fetch_step.status).to eq 'success' }
      it { expect(clear_step.status).to eq 'success' }
    end
  end
end
