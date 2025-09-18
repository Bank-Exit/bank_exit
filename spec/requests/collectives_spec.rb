require 'rails_helper'

RSpec.describe 'Collectives' do
  describe 'GET /collective' do
    subject! { get '/collective' }

    it { expect(response).to have_http_status :redirect }
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/collective" do
      subject! { get "/#{locale}/collective" }

      it { expect(response).to have_http_status :ok }
    end
  end
end
