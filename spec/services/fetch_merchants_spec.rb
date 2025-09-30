require 'rails_helper'

RSpec.describe FetchMerchants do
  subject(:call) { described_class.call }

  describe '[Overpass API]' do
    context 'when error' do
      before { stub_overpass_request_failure }

      it { expect { call }.to_not change { Merchant.count } }
      it { expect { call }.to have_broadcasted_to(:flashes) }
    end

    context 'when success' do
      before do
        stub_overpass_request_success
        allow(Merchants::CheckAndReportRemovedOnOSM).to receive(:call)
        allow(Merchants::AssignCountry).to receive(:call)
      end

      after { clear_files }

      it { expect { call }.to change { Merchant.count }.by(3) }

      describe '[files on disk]' do
        before { call }

        it 'creates JSON, GeoJSON and metadata files', :aggregate_failures do
          expect(File).to exist('spec/fixtures/files/last_fetch_at.txt')
          expect(File).to exist('spec/fixtures/files/export.json')
          expect(File).to exist('spec/fixtures/files/export.geojson')
          expect(File).to_not exist('spec/fixtures/files/missing_merchant_ids_from_open_street_map.txt')
        end

        it 'has same items count in GeoJSON as in JSON' do
          json = JSON.parse(File.read('spec/fixtures/files/export.geojson'))

          expect(json['features'].count).to eq 3
        end
      end
    end
  end

  describe '[Github API report removed merchants]' do
    before do
      stub_overpass_request_success
      allow(Merchants::AssignCountry).to receive(:call)
      allow(Merchants::CheckAndReportRemovedOnOSM).to receive(:call)
      call
    end

    after { clear_files }

    it { expect(Merchants::CheckAndReportRemovedOnOSM).to have_received(:call).with(['node/296731584', 'node/445766280', 'way/125059083']).once }
  end

  describe '[Reactivate soft deleted merchants]' do
    before do
      stub_overpass_request_success
      allow(Merchants::AssignCountry).to receive(:call)
      allow(Merchants::CheckAndReportRemovedOnOSM).to receive(:call)
      allow(Merchants::CheckAndReactivate).to receive(:call)

      call
    end

    after { clear_files }

    it { expect(Merchants::CheckAndReactivate).to have_received(:call).once }
  end

  describe '[Reverse geocoding Nominatim API]' do
    before do
      stub_overpass_request_success
      allow(Merchants::AssignCountry).to receive(:call)
      allow(Merchants::CheckAndReportRemovedOnOSM).to receive(:call)

      call
    end

    after { clear_files }

    it { expect(Merchants::AssignCountry).to have_received(:call).once }
  end

  private

  def clear_files
    FileUtils.remove('spec/fixtures/files/last_fetch_at.txt')
    FileUtils.remove('spec/fixtures/files/export.json')
    FileUtils.remove('spec/fixtures/files/export.geojson')

    FileUtils.rm_rf(Rails.root.join('spec/fixtures/files/merchants'))
  end
end
