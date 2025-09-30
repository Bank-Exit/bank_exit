require 'rails_helper'

RSpec.describe Merchants::CheckAndReactivate do
  describe '#call' do
    subject(:call) do
      described_class.call(geojson_merchant_ids)
    end

    let!(:deleted_merchant) { create :merchant, :deleted, identifier: '123456789' }
    let!(:another_deleted_merchant) { create :merchant, :deleted, identifier: '987654321' }
    let!(:available_merchant) { create :merchant, identifier: 'abcdefghi' }

    let(:geojson_merchant_ids) { ['node/123456789', 'node/abcdefghi'] }

    before { call }

    it { expect(deleted_merchant).to be_available }
    it { expect(another_deleted_merchant).to be_soft_deleted }
    it { expect(available_merchant).to be_available }
  end
end
