require 'rails_helper'

RSpec.describe Merchants::OSMConverter do
  describe '#call' do
    subject(:data) { described_class.call(merchant_proposal) }

    let(:merchant_proposal) do
      build_stubbed :merchant_proposal,
                    name: 'John Doe',
                    email: 'foobar@demo.test',
                    phone: '+1234567890',
                    website: 'https://foobar.test',
                    category: :bakery,
                    street: '1 Foobar Street',
                    postcode: '1234ABC',
                    city: 'Barbaz',
                    country: 'CH',
                    coins: %w[bitcoin monero gold],
                    ask_kyc: false,
                    description: 'Lorem ipsum dolor sit amet',
                    contact_twitter: 'foobarbaz',
                    contact_facebook: 'https://facebook.com/Foobar',
                    last_survey_on: '2025-11-11',
                    delivery: true,
                    latitude: 123.456,
                    longitude: 456.123,
                    opening_hours: 'Mo-Su 09:00-18:00'
    end

    it 'has correct OSM key=value format' do
      expect(data).to eq <<~TEXT.chomp
        name=John Doe
        category=Bakery
        description=Lorem ipsum dolor sit amet
        email=foobar@demo.test
        phone=+1234567890
        website=https://foobar.test
        addr:street=1 Foobar Street
        addr:postcode=1234ABC
        addr:city=Barbaz
        addr:country=CH
        payment:onchain=yes
        currency:XBT=yes
        currency:XMR=yes
        payment:gold=yes
        payment:kyc=no
        contact:facebook=https://facebook.com/Foobar
        contact:twitter=https://x.com/foobarbaz
        delivery=yes
        opening_hours=Mo-Su 09:00-18:00
        survey:date=2025-11-11

        --- EXTRA DATA TO IGNORE ---
        country=🇨🇭 Switzerland
        latitude=123.456
        longitude=456.123
      TEXT
    end

    describe '[payment:kyc]' do
      let(:merchant_proposal) do
        build_stubbed :merchant_proposal, ask_kyc: ask_kyc
      end

      context 'when value is nil' do
        let(:ask_kyc) { nil }

        it { is_expected.to_not match 'payment:kyc' }
      end

      context 'when value is true' do
        let(:ask_kyc) { true }

        it { is_expected.to match('payment:kyc=yes') }
      end

      context 'when value is false' do
        let(:ask_kyc) { false }

        it { is_expected.to match('payment:kyc=no') }
      end
    end

    describe '[delivery]' do
      let(:merchant_proposal) do
        build_stubbed :merchant_proposal,
                      delivery: delivery,
                      delivery_zone: delivery_zone
      end

      let(:delivery_zone) { nil }

      context 'when value is false' do
        let(:delivery) { false }

        it { is_expected.to_not match 'delivery=yes' }
        it { is_expected.to_not match 'delivery_zone=' }
      end

      context 'when value is true' do
        let(:delivery) { true }

        context 'when :delivery_zone is set' do
          let(:delivery_zone) { 'World' }

          it { is_expected.to match 'delivery=yes' }
          it { is_expected.to match 'delivery_zone=World' }
        end

        context 'when :delivery_zone is not set' do
          let(:delivery_zone) { nil }

          it { is_expected.to match 'delivery=yes' }
          it { is_expected.to_not match 'delivery_zone=' }
        end
      end
    end

    describe '[currencies]' do
      let(:merchant_proposal) do
        build_stubbed :merchant_proposal, coins: coins
      end

      context 'when no coins are present' do
        let(:coins) { [] }

        it { is_expected.to_not match 'payment:onchain' }
        it { is_expected.to_not match 'currency:XBT' }
        it { is_expected.to_not match 'currency:XMR' }
        it { is_expected.to_not match 'currency:XG1' }
      end

      context 'when bitcoin is true' do
        let(:coins) { ['bitcoin'] }

        it { is_expected.to match 'payment:onchain=yes' }
        it { is_expected.to match 'currency:XBT=yes' }
        it { is_expected.to_not match 'currency:XMR' }
        it { is_expected.to_not match 'currency:XG1' }
      end

      context 'when monero is true' do
        let(:coins) { ['monero'] }

        it { is_expected.to match 'payment:onchain=yes' }
        it { is_expected.to match 'currency:XMR=yes' }
        it { is_expected.to_not match 'currency:XBT' }
        it { is_expected.to_not match 'currency:XG1' }
      end

      context 'when june is true' do
        let(:coins) { ['june'] }

        it { is_expected.to match 'payment:onchain=yes' }
        it { is_expected.to_not match 'currency:XMR' }
        it { is_expected.to_not match 'currency:XBT' }
        it { is_expected.to match 'currency:XG1=yes' }
      end

      context 'when silver is true' do
        let(:coins) { ['silver'] }

        it { is_expected.to_not match 'payment:onchain' }
        it { is_expected.to_not match 'currency:XMR' }
        it { is_expected.to_not match 'currency:XBT' }
        it { is_expected.to_not match 'currency:XG1' }
        it { is_expected.to match 'silver=yes' }
        it { is_expected.to_not match 'gold' }
      end

      context 'when gold is true' do
        let(:coins) { ['gold'] }

        it { is_expected.to_not match 'payment:onchain' }
        it { is_expected.to_not match 'currency:XMR' }
        it { is_expected.to_not match 'currency:XBT' }
        it { is_expected.to_not match 'currency:XG1' }
        it { is_expected.to_not match 'silver' }
        it { is_expected.to match 'gold=yes' }
      end
    end
  end
end
