require 'rails_helper'

RSpec.describe 'Glossaries' do
  describe 'GET /glossaries' do
    subject! { get '/glossaries' }

    it { expect(response).to have_http_status :redirect }
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/glossaries" do
      subject! { get "/#{locale}/glossaries" }

      it { expect(response).to have_http_status :ok }
    end
  end
end
