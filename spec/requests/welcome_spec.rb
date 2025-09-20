require 'rails_helper'

RSpec.describe 'Welcome' do
  before do
    create_list :merchant, 3
    create_list :directory, 3
  end

  describe 'GET /' do
    subject! { get '/' }

    it { expect(response).to have_http_status :redirect }
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}" do
      subject! { get "/#{locale}" }

      it { expect(response).to have_http_status :ok }
    end
  end
end
