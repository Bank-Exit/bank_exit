require 'rails_helper'

RSpec.describe 'Admin::MerchantSyncs' do
  describe 'GET /admin/merchant_syncs' do
    subject { get '/admin/merchant_syncs' }

    before do
      create :merchant_sync, :pending
      create :merchant_sync, :success
      create :merchant_sync, :error
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

  describe 'GET /admin/merchant_syncs.turbo_stream' do
    subject do
      get '/admin/merchant_syncs',
          params: { query: query },
          as: :turbo_stream
    end

    before do
      create :merchant_sync, :success,
             payload_added_merchants: { foo: 'bar' }
    end

    include_context 'with user role', :super_admin

    context 'when `query` is present' do
      let(:query) { 'foo' }

      it_behaves_like 'access granted'
    end

    context 'when `query` is not present' do
      let(:query) { nil }

      it_behaves_like 'access granted'
    end
  end

  describe 'GET /admin/merchant_syncs/:id.turbo_stream' do
    subject { get "/admin/merchant_syncs/#{merchant_sync.id}", as: :turbo_stream }

    let(:merchant_sync) { create :merchant_sync, :success, :with_payloads }

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
end
