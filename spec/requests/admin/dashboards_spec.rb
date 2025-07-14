require 'rails_helper'

RSpec.describe 'Admin::Dashboards' do
  before do
    create_list :merchant, 2, bitcoin: true, monero: true
    create :merchant, country: 'FR', category: 'restaurant'
    create :merchant, country: 'FR', june: true
  end

  describe 'GET /admin/dashboard' do
    subject { get '/admin/dashboard' }

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
end
