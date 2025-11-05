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

    it { expect { call }.to change { Merchant.count }.by(-1) }

    context 'when merchant is available' do
      before { call }

      it { expect { available_merchant.reload }.to_not raise_error }
      it { expect(MerchantSync.last.status).to eq 'success' }
    end

    context 'when delta time is not yet exceeded' do
      before { call }

      it { expect { deleted_below_delta_bitcoin.reload }.to_not raise_error }
      it { expect { deleted_below_delta_monero.reload }.to_not raise_error }
      it { expect { deleted_below_delta_june.reload }.to_not raise_error }
      it { expect(MerchantSync.last.status).to eq 'success' }
    end

    context 'when delta time is exceeded' do
      before { call }

      it { expect { deleted_above_delta_bitcoin.reload }.to raise_error(ActiveRecord::RecordNotFound) }
      it { expect { deleted_above_delta_monero.reload }.to_not raise_error }
      it { expect { deleted_above_delta_june.reload }.to_not raise_error }
      it { expect(MerchantSync.last.status).to eq 'success' }
    end
  end
end
