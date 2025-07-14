require 'rails_helper'

RSpec.describe 'Admin::Users' do
  describe 'GET /admin/profile/edit' do
    subject { get '/admin/profile/edit' }

    context 'when logged in' do
      include_context 'with user role', :admin
      it_behaves_like 'access granted'
    end

    context 'when logged out' do
      include_context 'without login'
      it_behaves_like 'access unauthenticated'
    end
  end

  describe 'PATCH /admin/profile' do
    subject(:action) { patch '/admin/profile', params: valid_params }

    let(:valid_params) { { user: { email: 'newemail@demo.test' } } }

    context 'when logged in' do
      include_context 'with user role', :admin
      it_behaves_like 'access granted with redirection' do
        let(:redirection_url) { admin_root_path }
        let(:flash_notice) { 'Votre profil a bien été mis à jour' }

        it { expect { action }.to change { current_user.reload.email }.to 'newemail@demo.test' }
      end
    end

    context 'when logged out' do
      include_context 'without login'
      it_behaves_like 'access unauthenticated'
    end
  end
end
