require 'rails_helper'

RSpec.describe Merchants::AssignCountry do
  describe '#call' do
    subject(:call) { described_class.call }

    context 'when merchant has already a country' do
      let!(:merchant) do
        create :merchant, latitude: 1.1,
                          longitude: 2.2,
                          country: 'CH',
                          continent_code: 'EU'
      end

      before { call }

      it { expect(merchant.reload.country).to eq 'CH' }
      it { expect(merchant.reload.continent_code).to eq 'EU' }
    end

    context 'when merchant does not have a country' do
      let!(:merchant) do
        model = build :merchant, trait, country: nil
        model.save(validate: false)
        model
      end

      let(:trait) { :with_latlon }

      before do
        freeze_time
        stub_geocoder_from_fixture!

        call
      end

      context 'when merchant has a France lat/lon' do
        it { expect(merchant.reload.country).to eq 'FR' }
        it { expect(merchant.reload.continent_code).to eq 'EU' }
      end

      context 'when merchant has a French Polynesia lat/lon' do
        let(:trait) { :french_polynesia }

        it { expect(merchant.reload.country).to eq 'PF' }
        it { expect(merchant.reload.continent_code).to eq 'OC' }
      end

      context 'when merchant has a Guadeloupe lat/lon' do
        let(:trait) { :guadeloupe }

        it { expect(merchant.reload.country).to eq 'GP' }
        it { expect(merchant.reload.continent_code).to eq 'NA' }
      end

      context 'when merchant has a Martinique lat/lon' do
        let(:trait) { :martinique }

        it { expect(merchant.reload.country).to eq 'MQ' }
        it { expect(merchant.reload.continent_code).to eq 'NA' }
      end

      context 'when merchant has a Reunion lat/lon' do
        let(:trait) { :reunion }

        it { expect(merchant.reload.country).to eq 'RE' }
        it { expect(merchant.reload.continent_code).to eq 'AF' }
      end

      context 'when merchant has a Mayotte lat/lon' do
        let(:trait) { :mayotte }

        it { expect(merchant.reload.country).to eq 'YT' }
        it { expect(merchant.reload.continent_code).to eq 'AF' }
      end
    end
  end
end
