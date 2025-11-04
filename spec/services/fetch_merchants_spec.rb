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
        allow(Merchants::AssignCountry).to receive(:call) { {} }
      end

      it { expect { call }.to change { Merchant.count }.by(3) }
    end
  end

  describe '[Github API report removed merchants]' do
    before do
      stub_overpass_request_success
      allow(Merchants::AssignCountry).to receive(:call) { {} }
      allow(Merchants::CheckAndReportRemovedOnOSM).to receive(:call)
      call
    end

    it { expect(Merchants::CheckAndReportRemovedOnOSM).to have_received(:call).with(['node/296731584', 'node/445766280', 'way/125059083']).once }
  end

  describe '[Reactivate soft deleted merchants]' do
    before do
      stub_overpass_request_success
      allow(Merchants::AssignCountry).to receive(:call) { {} }
      allow(Merchants::CheckAndReportRemovedOnOSM).to receive(:call)
      allow(Merchants::CheckAndReactivate).to receive(:call)

      call
    end

    it { expect(Merchants::CheckAndReactivate).to have_received(:call).once }
  end

  describe '[Reverse geocoding Nominatim API]' do
    before do
      stub_overpass_request_success
      allow(Merchants::AssignCountry).to receive(:call) { {} }
      allow(Merchants::CheckAndReportRemovedOnOSM).to receive(:call)

      call
    end

    it { expect(Merchants::AssignCountry).to have_received(:call).once }
  end
end
