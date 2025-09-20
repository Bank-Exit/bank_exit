require 'rails_helper'

RSpec.describe 'Media' do
  describe 'GET /media' do
    subject! { get '/media' }

    it { expect(response).to have_http_status :redirect }
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/media" do
      subject! { get "/#{locale}/media" }

      it { expect(response).to have_http_status :ok }
    end
  end
end
