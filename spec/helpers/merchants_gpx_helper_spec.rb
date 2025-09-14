require 'rails_helper'

RSpec.describe MerchantsGPXHelper do
  describe '#merchant_icon' do
    subject { helper.merchant_icon(merchant) }

    context 'when merchant is :monero' do
      let(:merchant) { build :merchant, :monero }

      it { is_expected.to eq '🟠' }
    end

    context 'when merchant is :bitcoin' do
      let(:merchant) { build :merchant, :bitcoin }

      it { is_expected.to eq '🟡' }
    end

    context 'when merchant is :june' do
      let(:merchant) { build :merchant, :june }

      it { is_expected.to eq '🌀' }
    end

    context 'when merchant is :bitcoin, :lightning, :monero and :june' do
      let(:merchant) { build :merchant, :bitcoin, :lightning, :monero, :june }

      it { is_expected.to eq '🟠 🟡 🌀' }
    end
  end
end
