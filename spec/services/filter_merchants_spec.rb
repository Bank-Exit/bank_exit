require 'rails_helper'

RSpec.describe FilterMerchants do
  describe '#call' do
    subject do
      described_class.call(
        query: query, category: category, coins: coins
      )
    end

    let(:query) { 'foobar' }
    let(:category) { 'restaurant' }
    let(:coins) { ['bitcoin'] }

    let!(:merchant_match_all_criteria) do
      create :merchant, name: 'foobar', category: 'restaurant',
                        coins: %w[bitcoin monero], bitcoin: true,
                        lightning: true, monero: true
    end

    before do
      create :merchant, name: 'foobar'
      create :merchant, category: 'restaurant'
      create :merchant, coins: ['bitcoin']
      create :merchant, full_address: '1 street foobar, CITY'
      create :merchant, name: 'Do not match'
      create :merchant, category: 'shopping'
      create :merchant, coins: ['june']
    end

    it { is_expected.to contain_exactly(merchant_match_all_criteria) }
  end

  describe '[onchain only]' do
    subject do
      described_class.call(onchain_only: onchain_only, coins: coins)
    end

    let!(:merchant_onchain) { create :merchant, :bitcoin, :lightning, :monero }
    let!(:merchant_lightning) { create :merchant, :lightning }
    let!(:merchant_contactless) { create :merchant, :lightning_contactless }
    let!(:merchant_june) { create :merchant, :june }

    context 'without coins specifications' do
      let(:coins) { [] }

      context 'when filtering with onchain only' do
        let(:onchain_only) { true }

        it { is_expected.to contain_exactly(merchant_onchain, merchant_june) }
      end

      context 'when not filtering onchain' do
        let(:onchain_only) { false }

        it { is_expected.to contain_exactly(merchant_onchain, merchant_lightning, merchant_contactless, merchant_june) }
      end
    end

    context 'with coins specifications' do
      let(:coins) { ['bitcoin'] }

      context 'when filtering with onchain only' do
        let(:onchain_only) { true }

        it { is_expected.to contain_exactly(merchant_onchain) }
      end

      context 'when not filtering onchain' do
        let(:onchain_only) { false }

        it { is_expected.to contain_exactly(merchant_onchain, merchant_lightning, merchant_contactless) }
      end
    end
  end

  describe '[continent]' do
    subject do
      described_class.call(continent: continent_code)
    end

    let!(:merchant_europe) { create :merchant, continent_code: 'EU' }
    let!(:merchant_south_america) { create :merchant, continent_code: 'SA' }

    context 'when continent is EU' do
      let(:continent_code) { 'EU' }

      it { is_expected.to contain_exactly(merchant_europe) }
    end

    context 'when continent is SA' do
      let(:continent_code) { 'SA' }

      it { is_expected.to contain_exactly(merchant_south_america) }
    end
  end
end
