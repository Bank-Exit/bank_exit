require 'rails_helper'

RSpec.describe 'Admin::Merchants::BatchActions' do
  describe 'PATCH /admin/merchants/batch_actions' do
    subject(:action) { patch '/admin/merchants/batch_actions', params: params }

    let(:params) { { batch_actions: { directory_ids: Merchant.ids.join(',') } } }

    let!(:merchant) { create :merchant, :deleted }
    let!(:merchant_2) { create :merchant, :deleted }

    %i[super_admin admin publisher].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_merchants_path(show_deleted: true) }
          let(:flash_notice) { 'Les commerçants ont bien été réactivés' }
        end

        it { expect { action }.to change { merchant.reload.deleted_at }.to nil }
        it { expect { action }.to change { merchant_2.reload.deleted_at }.to nil }
      end
    end

    %i[moderator].each do |role|
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

  describe 'DELETE /admin/merchants/batch_actions' do
    subject(:action) { delete '/admin/merchants/batch_actions', params: params }

    let(:params) { { batch_actions: { directory_ids: Merchant.ids.join(',') } } }

    before do
      create_list :merchant, 2, :deleted
    end

    %i[super_admin admin publisher].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_merchants_path(show_deleted: true) }
          let(:flash_notice) { 'Les commerçants ont bien été supprimés' }
        end

        it { expect { action }.to change { Merchant.count }.by(-2) }
      end
    end

    %i[moderator].each do |role|
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
