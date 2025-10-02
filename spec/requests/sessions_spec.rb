require 'rails_helper'

RSpec.describe 'Risks' do
  describe 'GET /session' do
    subject! { get '/session' }

    it 'redirects to new session form' do
      follow_redirect!
      expect(response).to redirect_to new_session_path
    end
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/session" do
      subject! { get "/#{locale}/session" }

      it { expect(response).to redirect_to send("new_session_#{locale}_path") }
    end

    describe "GET /#{locale}/session/new" do
      subject { get "/#{locale}/session/new" }

      context 'when already logged in' do
        include_context 'with user role', :admin
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_root_path }
        end
      end

      context 'when logged out' do
        include_context 'without login'
        it_behaves_like 'access granted'
      end
    end

    describe "POST /#{locale}/session" do
      subject(:action) { post "/#{locale}/session", params: params }

      context 'when credentials are invalid' do
        let(:params) do
          { session: { email: 'fake@demo.test', password: 'fake' } }
        end

        before { action }

        it { expect(response).to have_http_status :unprocessable_content }
        it { expect(flash[:alert]).to eq 'Login failed' }
      end

      context 'when credentials are valid' do
        before do
          create :user, email: 'foobar@demo.test', password: 'password', enabled: enabled
          action
        end

        let(:params) do
          { session: { email: 'foobar@demo.test', password: 'password' } }
        end

        context 'when user is enabled' do
          let(:enabled) { true }

          it { expect(response).to redirect_to admin_root_path }
        end

        context 'when user is not enabled' do
          let(:enabled) { false }

          it { expect(response).to have_http_status :unprocessable_content }
          it { expect(flash[:alert]).to eq 'Login failed' }
        end
      end
    end

    describe "DELETE /#{locale}/session" do
      subject! { delete "/#{locale}/session" }

      it { expect(response).to redirect_to send("new_session_#{locale}_path") }
    end
  end
end
