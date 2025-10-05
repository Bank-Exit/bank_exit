require 'rails_helper'

RSpec.describe 'Admin::Merchants' do
  let!(:merchant) { create :merchant }

  describe 'GET /admin/merchants' do
    subject { get '/admin/merchants' }

    before do
      merchants = create_list :merchant, 3
      create_list :comment, 2, commentable: merchants.first
    end

    %i[super_admin admin publisher moderator].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted'
      end
    end

    context 'when logged out' do
      include_context 'without login'
      it_behaves_like 'access unauthenticated'
    end
  end

  describe 'GET /admin/merchants/:id' do
    subject { get "/admin/merchants/#{merchant.to_param}" }

    %i[super_admin admin publisher moderator].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted'
      end
    end

    context 'when logged out' do
      include_context 'without login'
      it_behaves_like 'access unauthenticated'
    end
  end

  describe 'GET /admin/merchants/:id/edit' do
    subject { get "/admin/merchants/#{merchant.to_param}/edit" }

    %i[super_admin admin publisher].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted'
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

  describe 'PATCH /admin/merchants/:id' do
    subject { patch "/admin/merchants/#{merchant.to_param}", params: valid_params }

    let(:valid_params) { { merchant: { remove_logo: '1' } } }

    %i[super_admin admin publisher].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_merchants_path }
          let(:flash_notice) { I18n.t('admin.merchants.update.notice') }
        end
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

  describe 'DELETE /admin/merchants/:id' do
    subject(:action) { delete "/admin/merchants/#{merchant.to_param}" }

    let!(:merchant) { create :merchant, :deleted }

    %i[super_admin admin moderator].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_merchants_path(show_deleted: true) }
          let(:flash_notice) { I18n.t('admin.merchants.destroy.notice') }
        end

        it { expect { action }.to change { Merchant.count }.by(-1) }
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
