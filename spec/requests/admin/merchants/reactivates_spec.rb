require 'rails_helper'

RSpec.describe 'Admin::Merchants::Reactivates' do
  let(:headers) { basic_auth_headers }

  describe 'POST /admin/merchants/:merchant_id/reactivate' do
    subject(:action) { post path, headers: headers }

    let(:merchant) { create :merchant, :deleted }
    let(:method) { :post }
    let(:path) { "/admin/merchants/#{merchant.identifier}/reactivate" }

    context 'when credentials are valid' do
      before { action }

      it { expect(merchant.reload.deleted_at).to be_nil }
      it { expect(response).to redirect_to admin_merchants_path(show_deleted: true) }
      it { expect(flash[:notice]).to eq('Le commerçant a bien été réactivé') }
    end

    it_behaves_like 'an authenticated endpoint'
  end
end
