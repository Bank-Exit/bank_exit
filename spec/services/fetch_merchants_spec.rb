require 'rails_helper'

RSpec.describe FetchMerchants do
  subject(:call) { described_class.call }

  let(:merchant_sync) { MerchantSync.last }

  before do
    disable_feature :nostr

    allow(Merchants::CheckAndReportRemovedOnOSM).to receive(:call)
    allow(Merchants::AssignCountry).to receive(:call) { {} }
    allow(Merchants::CheckAndReactivate).to receive(:call)

    stub_overpass_request_success
  end

  describe '[Overpass API]' do
    let(:merchant_sync_step) { merchant_sync.merchant_sync_steps.overpass_api.first }

    context 'when error' do
      before { stub_overpass_request_failure }

      it { expect { call }.to_not change { Merchant.count } }
      it { expect { call }.to have_broadcasted_to(:flashes) }

      describe 'status' do
        before { call }

        it { expect(merchant_sync.status).to eq 'error' }
        it { expect(merchant_sync_step.status).to eq 'error' }
      end
    end

    context 'when success' do
      it { expect { call }.to change { Merchant.count }.by(3) }

      describe 'status' do
        before { call }

        it { expect(merchant_sync.status).to eq 'success' }
        it { expect(merchant_sync_step.status).to eq 'success' }
      end
    end
  end

  describe '[JSONToGeoJSON]' do
    let(:merchant_sync_step) { merchant_sync.merchant_sync_steps.convert_to_geojson.first }

    context 'when success' do
      before do
        allow(JSONToGeoJSON).to receive(:call) { { features: [] }.as_json }
        call
      end

      it { expect(JSONToGeoJSON).to have_received(:call).once }

      it { expect(merchant_sync.status).to eq 'success' }
      it { expect(merchant_sync_step.status).to eq 'success' }
    end

    context 'when error' do
      before do
        allow(JSONToGeoJSON).to receive(:call).and_raise(StandardError)
        call
      end

      it { expect(merchant_sync.status).to eq 'error' }
      it { expect(merchant_sync_step.status).to eq 'error' }
    end
  end

  describe '[Upsert data]' do
    let(:merchant_sync_step) { merchant_sync.merchant_sync_steps.save_data.first }

    context 'when success' do
      before do
        call
      end

      it { expect(merchant_sync.status).to eq 'success' }
      it { expect(merchant_sync_step.status).to eq 'success' }
    end

    context 'when error' do
      before do
        allow(Merchant).to receive(:upsert_all).and_raise(StandardError)
        call
      end

      it { expect(merchant_sync.status).to eq 'error' }
      it { expect(merchant_sync_step.status).to eq 'error' }
    end
  end

  describe '[JSON storage attachment]' do
    let(:merchant_sync_step) { merchant_sync.merchant_sync_steps.attach_json.first }

    context 'when success' do
      before do
        call
      end

      it { expect(merchant_sync.raw_json).to be_attached }
      it { expect(merchant_sync.status).to eq 'success' }
      it { expect(merchant_sync_step.status).to eq 'success' }
    end

    # FIXME: find a way to simulate attachment raise exception
    # context 'when error' do
    #   before do
    #     call
    #   end

    #   it { expect(merchant_sync.raw_json).to_not be_attached }
    #   it { expect(merchant_sync.status).to eq 'error' }
    #   it { expect(merchant_sync_step.status).to eq 'error' }
    # end
  end

  describe '[CheckAndReportRemovedOnOSM]' do
    let(:merchant_sync_step) { merchant_sync.merchant_sync_steps.notify_github.first }

    context 'when success' do
      before do
        call
      end

      it { expect(Merchants::CheckAndReportRemovedOnOSM).to have_received(:call).with(['node/296731584', 'node/445766280', 'way/125059083']).once }

      it { expect(merchant_sync.status).to eq 'success' }
      it { expect(merchant_sync_step.status).to eq 'success' }
    end

    context 'when error' do
      before do
        allow(Merchants::CheckAndReportRemovedOnOSM).to receive(:call).and_raise(StandardError)
        call
      end

      it { expect(merchant_sync.status).to eq 'success_with_error' }
      it { expect(merchant_sync_step.status).to eq 'error' }
    end
  end

  describe '[CheckAndReactivate]' do
    let(:merchant_sync_step) { merchant_sync.merchant_sync_steps.reactivate_disabled.first }

    context 'when success' do
      before do
        call
      end

      it { expect(Merchants::CheckAndReactivate).to have_received(:call).once }

      it { expect(merchant_sync.status).to eq 'success' }
      it { expect(merchant_sync_step.status).to eq 'success' }
    end

    context 'when error' do
      before do
        allow(Merchants::CheckAndReactivate).to receive(:call).and_raise(StandardError)
        call
      end

      it { expect(merchant_sync.status).to eq 'success_with_error' }
      it { expect(merchant_sync_step.status).to eq 'error' }
    end
  end

  describe '[AssignCountry]' do
    let(:merchant_sync_step) { merchant_sync.merchant_sync_steps.assign_country.first }

    context 'when success' do
      before do
        call
      end

      it { expect(Merchants::AssignCountry).to have_received(:call).once }

      it { expect(merchant_sync.status).to eq 'success' }
      it { expect(merchant_sync_step.status).to eq 'success' }
    end

    context 'when error' do
      before do
        allow(Merchants::AssignCountry).to receive(:call).and_raise(StandardError)
        call
      end

      it { expect(merchant_sync.status).to eq 'success_with_error' }
      it { expect(merchant_sync_step.status).to eq 'error' }
    end
  end

  describe '[NostrPublisher]' do
    let(:merchant_sync_step) { merchant_sync.merchant_sync_steps.publish_to_nostr.first }

    before do
      allow(NostrPublisher).to receive(:call)
    end

    context 'when :nostr feature is enabled' do
      before do
        enable_feature :nostr
      end

      context 'when new merchants have been referenced' do
        before do
          call
        end

        it { expect(NostrPublisher).to have_received(:call).with(instance_of(MerchantSync), identifier: instance_of(String)).once }

        it { expect(merchant_sync.status).to eq 'success' }
        it { expect(merchant_sync_step.status).to eq 'success' }
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
        disable_feature :nostr
        call
      end

      it { expect(NostrPublisher).to_not have_received(:call) }
    end

    context 'when :nostr feature raise an error' do
      before do
        enable_feature :nostr
        allow(NostrPublisher).to receive(:call).and_raise(NostrErrors::MissingPrivateKey)

        call
      end

      it { expect(merchant_sync.status).to eq 'success_with_error' }
      it { expect(merchant_sync_step.status).to eq 'error' }
    end
  end
end
