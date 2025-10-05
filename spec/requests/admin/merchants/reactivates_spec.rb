require 'rails_helper'

RSpec.describe 'Admin::Merchants::Reactivates' do
  describe 'POST /admin/merchants/:merchant_id/reactivate' do
    subject(:action) { post "/admin/merchants/#{merchant.to_param}/reactivate" }

    let(:merchant) { create :merchant, :deleted }

    %i[super_admin admin moderator].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_merchants_path(show_deleted: true) }
          let(:flash_notice) { I18n.t('admin.merchants.reactivates.create.notice') }
        end

        it { expect { action }.to change { merchant.reload.deleted_at }.to nil }
      end
    end

    %i[publisher].each do |role|
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
