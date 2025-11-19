require 'rails_helper'

RSpec.describe FetchMerchants do
  subject(:call) { described_class.call }

  before do
    disable_feature :nostr
  end

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

  describe '[NostrPublisher]' do
    before do
      allow(Merchants::AssignCountry).to receive(:call) { {} }
      allow(Merchants::CheckAndReportRemovedOnOSM).to receive(:call)
      allow(Merchants::CheckAndReactivate).to receive(:call)

      allow(NostrPublisher).to receive(:call)
    end

    context 'when :nostr feature is enabled' do
      before do
        enable_feature :nostr
      end

      context 'when new merchants have been referenced' do
        before do
          stub_overpass_request_success
          call
        end

        it { expect(NostrPublisher).to have_received(:call).with(instance_of(MerchantSync), identifier: instance_of(String)).once }
      end

      context 'when no new merchants have been referenced' do
        before do
          stub_overpass_request_success(empty_response: true)
          call
        end

        it { expect(NostrPublisher).to_not have_received(:call) }
      end
    end

    context 'when :nostr feature is disabled' do
      before do
        stub_overpass_request_success
        disable_feature :nostr
        call
      end

      it { expect(NostrPublisher).to_not have_received(:call) }
    end
  end
end
