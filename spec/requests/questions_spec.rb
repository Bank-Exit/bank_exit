require 'rails_helper'

RSpec.describe 'Questions' do
  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/questions/results" do
      subject! { get "/#{locale}/questions/results", params: params }

      let(:params) do
        {
          questions: {
            profile: 'company',
            level: 'intermediate',
            service: service
          }
        }
      end

      context 'when combination is not (yet) handled' do
        let(:service) { 'foobar' }

        it { expect(response).to have_http_status :ok }
      end

      context 'when :accounting' do
        let(:service) { 'accounting' }

        it { expect(response).to redirect_to send("tutorial_#{locale}_path", 'accounting') }
      end

      context 'when :messaging' do
        let(:service) { 'messaging' }

        it { expect(response).to redirect_to send("tutorial_#{locale}_path", 'session-messaging') }
      end

      context 'when :social_network' do
        let(:service) { 'social_network' }

        it { expect(response).to redirect_to send("tutorial_#{locale}_path", 'nostr-social-network') }
      end

      context 'when :buy_no_kyc' do
        let(:service) { 'buy_no_kyc' }

        it { expect(response).to redirect_to send("tutorial_#{locale}_path", 'bitcoin-nokyc') }
      end

      context 'when :kitty' do
        let(:service) { 'kitty' }

        it { expect(response).to redirect_to send("tutorial_#{locale}_path", 'funding-monero') }
      end

      context 'when :debank' do
        let(:service) { 'debank' }

        it { expect(response).to redirect_to send("tutorial_#{locale}_path", 'crash-course') }
      end

      context 'when :node' do
        let(:service) { 'node' }

        it { expect(response).to redirect_to send("tutorial_#{locale}_path", 'monero-node-easymonerod') }
      end

      context 'when :anonymous' do
        let(:service) { 'anonymous' }

        it { expect(response).to redirect_to send("tutorial_#{locale}_path", 'cakewallet-monero') }
      end
    end

    describe "POST /#{locale}/questions/fetch_services" do
      subject! do
        post "/#{locale}/questions/fetch_services", params: params, as: :turbo_stream
      end

      let(:params) do
        {
          questions: {
            profile: 'company',
            level: level
          }
        }
      end

      context 'when service is not handled' do
        let(:level) { :fake }

        it { expect(response).to have_http_status :ok }
      end

      context 'when service is :zero_knowledge' do
        let(:level) { :zero_knowledge }

        it { expect(response).to have_http_status :ok }
      end

      context 'when service is :beginner' do
        let(:level) { :beginner }

        it { expect(response).to have_http_status :ok }
      end

      context 'when service is :intermediate' do
        let(:level) { :intermediate }

        it { expect(response).to have_http_status :ok }
      end

      context 'when service is :expert' do
        let(:level) { :expert }

        it { expect(response).to have_http_status :ok }
      end
    end

    describe "POST /#{locale}/questions/fetch_levels" do
      subject! do
        post "/#{locale}/questions/fetch_levels", params: params, as: :turbo_stream
      end

      let(:params) do
        { questions: { profile: profile } }
      end

      let(:profile) { :company }

      it { expect(response).to have_http_status :ok }
    end
  end
end
