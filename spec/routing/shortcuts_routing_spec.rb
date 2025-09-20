require 'rails_helper'

RSpec.describe 'Shortcuts', type: :request do
  describe '/asdb' do
    subject! { get('/asdb') }

    it 'follows redirects to english article', :aggregate_failures do
      expect(response).to redirect_to('/blogs/bank-exit-assembly-2025')

      follow_redirect!

      expect(response).to redirect_to('/en/blogs/bank-exit-assembly-2025')
    end
  end

  I18n.available_locales.each do |locale|
    describe "/#{locale}/asdb" do
      subject! { get("/#{locale}/asdb") }

      it { is_expected.to redirect_to("/#{locale}/blogs/bank-exit-assembly-2025") }
    end
  end
end
