require 'rails_helper'

def tutorial_ids
  %w[
    cakewallet-monero crash-course session-messaging
    nostr-social-network bitcoin-nokyc funding-monero
    monero-node-easymonerod documentation-embed-map accounting
    cryptopayment-for-business
  ]
end

RSpec.describe 'Tutorials' do
  let(:invalid_tutorial_id) { 'fake' }

  before { create :merchant, country: 'FR' }

  describe 'GET /tutorials' do
    subject! { get '/tutorials/' }

    it { expect(response).to have_http_status :redirect }
  end

  describe 'GET /tutorials/:id' do
    tutorial_ids.each do |tutorial_id|
      context "when #{tutorial_id} tutorial" do
        subject! { get "/tutorials/#{tutorial_id}" }

        it { expect(response).to have_http_status :redirect }
      end
    end

    context 'when tutorial does not exist' do
      subject! { get "/tutorials/#{invalid_tutorial_id}" }

      it { expect(response).to have_http_status :redirect }
    end
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/tutorials" do
      subject! { get "/#{locale}/tutorials/" }

      it { expect(response).to have_http_status :ok }
    end

    describe "GET /#{locale}/tutorials/:id" do
      tutorial_ids.each do |tutorial_id|
        context "when #{tutorial_id} tutorial" do
          subject! { get "/#{locale}/tutorials/#{tutorial_id}" }

          it { expect(response).to have_http_status :ok }
        end

        context 'when tutorial does not exist' do
          subject! { get "/#{locale}/tutorials/#{invalid_tutorial_id}" }

          it { expect(response).to have_http_status :not_found }
        end
      end
    end
  end
end
