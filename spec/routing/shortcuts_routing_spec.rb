require 'rails_helper'

RSpec.describe 'Shortcuts', type: :request do
  describe '/asdb' do
    subject! { get('/asdb') }

    it 'redirects to external asdb website' do
      expect(response).to redirect_to('https://libre-market.com/asdb')
    end
  end

  TEST_LOCALES.each do |locale|
    describe "/#{locale}/asdb" do
      subject! { get("/#{locale}/asdb") }

      it { is_expected.to redirect_to("/#{locale}/blogs/bank-exit-assembly-2026") }
    end
  end
end
