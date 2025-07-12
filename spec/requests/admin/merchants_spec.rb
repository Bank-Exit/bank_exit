require 'rails_helper'

RSpec.describe 'Admin::Merchants' do
  let(:headers) { basic_auth_headers }

  describe 'GET /admin/merchants' do
    subject(:action) { get path, headers: headers }

    let(:method) { :get }
    let(:path) { '/admin/merchants' }

    context 'when credentials are valid' do
      before do
        create :merchant, :deleted

        merchants = create_list :merchant, 3
        create_list :comment, 2, commentable: merchants.first

        create :comment, commentable: merchants.second
        create :comment, commentable: merchants.third

        action
      end

      it { expect(response).to have_http_status :ok }
    end

    it_behaves_like 'an authenticated endpoint'
  end

  describe 'GET /admin/merchants/:id' do
    subject(:action) { get path, headers: headers }

    let(:merchant) { create :merchant }
    let(:method) { :get }
    let(:path) { "/admin/merchants/#{merchant.identifier}" }

    context 'when credentials are valid' do
      before do
        create_list :comment, 3, commentable: merchant
        action
      end

      it { expect(response).to have_http_status :ok }
    end

    it_behaves_like 'an authenticated endpoint'
  end

  describe 'DELETE /admin/merchants/:id' do
    subject(:action) { delete path, headers: headers }

    let!(:merchant) { create :merchant, :deleted }
    let(:method) { :delete }
    let(:path) { "/admin/merchants/#{merchant.identifier}" }

    context 'when credentials are valid' do
      it { expect { action }.to change { Merchant.count }.by(-1) }

      describe '[HTTP status]' do
        before { action }

        it { expect(response).to redirect_to admin_merchants_path(show_deleted: true) }
        it { expect(flash[:notice]).to eq('Le commerçant a bien été supprimé') }
      end
    end

    it_behaves_like 'an authenticated endpoint'
  end
end
