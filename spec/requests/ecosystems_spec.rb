require 'rails_helper'

RSpec.describe 'Ecosystems' do
  before do
    create_list :ecosystem_item, 3
  end

  describe 'GET /ecosystem' do
    subject! { get '/ecosystem' }

    it { expect(response).to have_http_status :redirect }
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/ecosystem" do
      subject! { get "/#{locale}/ecosystem" }

      it { expect(response).to have_http_status :ok }
    end
  end
end
