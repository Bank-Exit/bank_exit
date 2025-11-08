require 'rails_helper'

RSpec.describe 'Contacts' do
  let(:contact_id) { 'Session' }
  let(:invalid_contact_id) { 'fakeID' }

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/contacts/:id.turbo_stream" do
      context 'when :session' do
        subject! { get "/#{locale}/contacts/Session", as: :turbo_stream }

        it { expect(response).to have_http_status :ok }
      end

      context 'when :nostr' do
        subject! { get "/#{locale}/contacts/Nostr", as: :turbo_stream }

        it { expect(response).to have_http_status :ok }
      end

      context 'when :email' do
        subject! { get "/#{locale}/contacts/Email", as: :turbo_stream }

        it { expect(response).to have_http_status :ok }
      end

      context 'when contact does not exist' do
        subject! { get "/#{locale}/contacts/#{invalid_contact_id}", as: :turbo_stream }

        it { expect(response).to have_http_status :not_found }
      end
    end
  end
end
