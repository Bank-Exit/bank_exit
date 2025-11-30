require 'rails_helper'

RSpec.describe 'Admin::NostrEvents' do
  let!(:merchant_sync) { create :merchant_sync }

  describe 'POST /admin/merchant_syncs/:merchant_sync_id/nostr_events' do
    subject(:action) do
      post "/admin/merchant_syncs/#{merchant_sync.id}/nostr_events"
    end

    %i[super_admin].each do |role|
      context "when role is #{role}" do
        before do
          allow(NostrPublisher).to receive(:call)
        end

        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_merchant_syncs_path }
          let(:flash_notice) { I18n.t('admin.nostr_events.create.notice') }
        end

        context 'when nostr step does not exist' do
          it { expect { action }.to change { merchant_sync.merchant_sync_steps.count }.by(1) }
        end

        context 'when nostr step already exist' do
          let!(:nostr_step) do
            create :merchant_sync_step,
                   merchant_sync: merchant_sync,
                   step: :publish_to_nostr,
                   status: :error
          end

          context 'when nostr_event exists' do
            before do
              create :nostr_event, nostr_eventable: merchant_sync
            end

            it { expect { action }.to change { nostr_step.reload.status }.from('error').to('success') }
          end

          context 'when nostr_event does not exist' do
            it { expect { action }.to change { nostr_step.reload.status }.from('error').to('success') }
          end
        end

        context 'when everything ends successfully' do
          before { action }

          it { expect(NostrPublisher).to have_received(:call).once }
        end

        context 'when an error is raised' do
          let(:nostr_step) do
            merchant_sync.merchant_sync_steps.publish_to_nostr.first
          end

          before do
            allow(NostrPublisher).to receive(:call).and_raise(StandardError, 'CrashTest')

            action
          end

          it { expect(nostr_step.status).to eq('error') }
          it { expect(response).to redirect_to admin_merchant_syncs_path }
          it { expect(flash[:alert]).to eq 'CrashTest' }
        end
      end
    end

    %i[admin publisher moderator].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access denied'
      end
    end

    context 'when logged out' do
      include_context 'without login'
      it_behaves_like 'access unauthenticated'
    end
  end
end
