require 'rails_helper'

RSpec.describe 'Admin::Users' do
  let!(:user) { create :user }

  describe 'GET /admin/users' do
    subject { get '/admin/users' }

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

  describe 'GET /admin/users/new' do
    subject { get '/admin/users/new' }

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

  describe 'POST /admin/users' do
    subject(:action) { post '/admin/users', params: valid_params }

    let(:valid_params) { { user: attributes_for(:user) } }

    %i[super_admin].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_users_path }
          let(:flash_notice) { "L'utilisateur a bien été créé" }
        end

        it { expect { action }.to change { User.count }.by(1) }
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

  describe 'GET /admin/users/:id/edit' do
    subject { get "/admin/users/#{user.id}/edit" }

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

  describe 'PATCH /admin/users/:id' do
    subject { patch "/admin/users/#{user.id}", params: valid_params }

    let(:valid_params) { { user: { email: 'newemail@demo.test' } } }

    %i[super_admin].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_users_path }
          let(:flash_notice) { "L'utilisateur a bien été modifié" }
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

  describe 'DELETE /admin/users/:id' do
    subject(:action) { delete "/admin/users/#{user.id}" }

    %i[super_admin].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_users_path }
          let(:flash_notice) { "L'utilisateur a bien été supprimé" }
        end

        it { expect { action }.to change { User.count }.by(-1) }
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

  describe 'POST /admin/users/:id/impersonate' do
    subject(:action) { post "/admin/users/#{user.id}/impersonate" }

    %i[super_admin].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_dashboard_path }
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

  describe 'POST /admin/users/stop_impersonating' do
    subject(:action) { post '/admin/users/stop_impersonating' }

    context 'when logged in' do
      include_context 'with user role', :super_admin
      it_behaves_like 'access granted with redirection' do
        let(:redirection_url) { admin_users_path }
      end
    end

    context 'when logged out' do
      include_context 'without login'
      it_behaves_like 'access unauthenticated'
    end
  end
end
