require 'rails_helper'

RSpec.describe 'Admin::Directories' do
  let!(:directory) { create :directory }

  describe 'GET /admin/directories' do
    subject { get '/admin/directories' }

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

  describe 'GET /admin/directories/new' do
    subject { get '/admin/directories/new' }

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

  describe 'POST /admin/directories' do
    subject(:action) { post '/admin/directories', params: valid_params }

    let(:valid_params) { { directory: attributes_for(:directory) } }

    %i[super_admin admin publisher].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_directories_path }
          let(:flash_notice) { I18n.t('admin.directories.create.notice') }
        end

        it { expect { action }.to change { Directory.count }.by(1) }
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

  describe 'GET /admin/directories/:id/edit' do
    subject { get "/admin/directories/#{directory.id}/edit" }

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

  describe 'PATCH /admin/directories/:id' do
    subject { patch "/admin/directories/#{directory.id}", params: valid_params }

    let(:valid_params) { { directory: { name_en: 'Name updated' } } }

    %i[super_admin admin publisher].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_directories_path }
          let(:flash_notice) { I18n.t('admin.directories.update.notice') }
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

  describe 'DELETE /admin/directories/:id' do
    subject(:action) { delete "/admin/directories/#{directory.id}" }

    %i[super_admin admin publisher].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_directories_path }
          let(:flash_notice) { I18n.t('admin.directories.destroy.notice') }
        end

        it { expect { action }.to change { Directory.count }.by(-1) }
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

  describe 'PATCH /admin/directories/:id/update_position' do
    subject(:action) do
      patch "/admin/directories/#{directory.id}/update_position",
            params: params,
            as: :turbo_stream
    end

    before do
      create_list :directory, 5
    end

    let(:params) { { directory: { position: 5 } } }

    %i[super_admin admin publisher].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted'

        it { expect { action }.to change { directory.reload.position }.from(1).to(5) }
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
