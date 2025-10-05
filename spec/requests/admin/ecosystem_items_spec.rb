require 'rails_helper'

RSpec.describe 'Admin::EcosystemItems' do
  let!(:ecosystem_item) { create :ecosystem_item }

  describe 'GET /admin/ecosystem_items' do
    subject { get '/admin/ecosystem_items' }

    before do
      create_list :ecosystem_item, 2
    end

    %i[super_admin admin].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted'
      end
    end

    %i[publisher moderator].each do |role|
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

  describe 'GET /admin/ecosystem_items/new' do
    subject { get '/admin/ecosystem_items/new' }

    %i[super_admin admin].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted'
      end
    end

    %i[publisher moderator].each do |role|
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

  describe 'POST /admin/ecosystem_items' do
    subject(:action) { post '/admin/ecosystem_items', params: valid_params }

    let(:valid_params) { { ecosystem_item: attributes_for(:ecosystem_item) } }

    %i[super_admin admin].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_ecosystem_items_path }
          let(:flash_notice) { I18n.t('admin.ecosystem_items.create.notice') }
        end

        it { expect { action }.to change { EcosystemItem.count }.by(1) }
      end
    end

    %i[publisher moderator].each do |role|
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

  describe 'GET /admin/ecosystem_items/:id/edit' do
    subject { get "/admin/ecosystem_items/#{ecosystem_item.id}/edit" }

    %i[super_admin admin].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted'
      end
    end

    %i[publisher moderator].each do |role|
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

  describe 'PATCH /admin/ecosystem_items/:id' do
    subject { patch "/admin/ecosystem_items/#{ecosystem_item.id}", params: valid_params }

    let(:valid_params) { { ecosystem_item: { name_en: 'Name updated' } } }

    %i[super_admin admin].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_ecosystem_items_path }
          let(:flash_notice) { I18n.t('admin.ecosystem_items.update.notice') }
        end
      end
    end

    %i[publisher moderator].each do |role|
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

  describe 'DELETE /admin/ecosystem_items/:id' do
    subject(:action) { delete "/admin/ecosystem_items/#{ecosystem_item.id}" }

    %i[super_admin admin].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_ecosystem_items_path }
          let(:flash_notice) { I18n.t('admin.ecosystem_items.destroy.notice') }
        end

        it { expect { action }.to change { EcosystemItem.count }.by(-1) }
      end
    end

    %i[publisher moderator].each do |role|
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
