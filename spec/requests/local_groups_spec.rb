require 'rails_helper'

RSpec.describe 'FAQs' do
  describe 'GET /local_groups' do
    subject! { get '/local_groups' }

    it { expect(response).to have_http_status :redirect }
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/local_groups" do
      subject! { get "/#{locale}/local_groups" }

      it { expect(response).to have_http_status :ok }
    end
  end
end
