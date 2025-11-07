require 'rails_helper'

RSpec.describe 'Admin::APITokens' do
  let!(:api_token) { create :api_token }

  describe 'GET /admin/api_tokens' do
    subject { get '/admin/api_tokens' }

    before do
      create_list :api_token, 3
      create :api_token, :expired
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

  describe 'GET /admin/api_tokens/new' do
    subject { get '/admin/api_tokens/new' }

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

  describe 'POST /admin/api_tokens' do
    subject(:action) { post '/admin/api_tokens', params: valid_params }

    let(:valid_params) { { api_token: attributes_for(:api_token) } }

    %i[super_admin].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_api_tokens_path }
          let(:flash_notice) { I18n.t('admin.api_tokens.create.notice') }
        end

        it { expect { action }.to change { APIToken.count }.by(1) }
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

  describe 'GET /admin/api_tokens/:id' do
    subject { get "/admin/api_tokens/#{api_token.id}", as: :turbo_stream }

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

  describe 'GET /admin/api_tokens/:id/edit' do
    subject { get "/admin/api_tokens/#{api_token.id}/edit" }

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

  describe 'PATCH /admin/api_tokens/:id' do
    subject { patch "/admin/api_tokens/#{api_token.id}", params: valid_params }

    let(:valid_params) { { api_token: { name: 'Name updated' } } }

    %i[super_admin].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_api_tokens_path }
          let(:flash_notice) { I18n.t('admin.api_tokens.update.notice') }
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

  describe 'DELETE /admin/api_tokens/:id' do
    subject(:action) { delete "/admin/api_tokens/#{api_token.id}" }

    %i[super_admin].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_api_tokens_path }
          let(:flash_notice) { I18n.t('admin.api_tokens.destroy.notice') }
        end

        it { expect { action }.to change { APIToken.count }.by(-1) }
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
