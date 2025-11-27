require 'rails_helper'

RSpec.describe 'Admin::MerchantSyncs' do
  describe 'GET /admin/merchant_syncs' do
    subject { get '/admin/merchant_syncs' }

    before do
      create :merchant_sync, :pending
      create :merchant_sync, :success
      create :merchant_sync, :error
    end

    %i[super_admin].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted'
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

  describe 'GET /admin/merchant_syncs.turbo_stream' do
    subject do
      get '/admin/merchant_syncs',
          params: { query: query },
          as: :turbo_stream
    end

    before do
      create :merchant_sync, :success,
             payload_added_merchants: { foo: 'bar' }
    end

    include_context 'with user role', :super_admin

    context 'when `query` is present' do
      let(:query) { 'foo' }

      it_behaves_like 'access granted'
    end

    context 'when `query` is not present' do
      let(:query) { nil }

      it_behaves_like 'access granted'
    end
  end

  describe 'GET /admin/merchant_syncs/:id.turbo_stream' do
    subject { get "/admin/merchant_syncs/#{merchant_sync.id}", as: :turbo_stream }

    let(:merchant_sync) { create :merchant_sync, :success, :with_payloads }

    %i[super_admin].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted'
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

  describe 'GET /admin/merchant_syncs/:id/edit' do
    subject { get "/admin/merchant_syncs/#{merchant_sync.id}/edit" }

    let(:merchant_sync) { create :merchant_sync, :success, :with_payloads }

    %i[super_admin].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted'
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

  describe 'PATCH /admin/merchants/:id' do
    subject(:action) do
      patch "/admin/merchant_syncs/#{merchant_sync.id}", params: valid_params
    end

    let!(:merchant_sync) { create :merchant_sync }
    let(:nostr_event) do
      create :nostr_event,
             nostr_eventable: merchant_sync,
             payload_event: { foo: 'bar' },
             payload_response: { foo: 'baz' }
    end

    let(:valid_params) do
      {
        merchant_sync: {
          added_merchants_count: 9999,
          payload_countries: { foo: 'bar edit' }.to_json,
          nostr_event_attributes: {
            id: nostr_event.id,
            payload_response: {
              foo: 'bar edit'
            }.to_json
          }
        }
      }
    end

    %i[super_admin].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_merchant_syncs_path }
          let(:flash_notice) { I18n.t('admin.merchant_syncs.update.notice') }
        end

        describe '[nostr_event]' do
          before { action }

          it { expect(nostr_event.reload.payload_response).to eq({ foo: 'bar edit' }.as_json) }
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

  describe 'DELETE /admin/merchants/:id' do
    subject(:action) { delete "/admin/merchant_syncs/#{merchant_sync.id}" }

    let!(:merchant_sync) { create :merchant_sync }

    %i[super_admin].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_merchant_syncs_path }
          let(:flash_notice) { I18n.t('admin.merchant_syncs.destroy.notice') }
        end

        it { expect { action }.to change { MerchantSync.count }.by(-1) }
      end
    end

    %i[admin moderator publisher].each do |role|
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
