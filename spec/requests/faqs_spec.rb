require 'rails_helper'

RSpec.describe 'FAQs' do
  describe 'GET /faq' do
    subject! { get '/faq' }

    it { expect(response).to have_http_status :redirect }
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/faq" do
      subject! { get "/#{locale}/faq" }

      it { expect(response).to have_http_status :ok }
    end
  end
end
