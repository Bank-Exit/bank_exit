require 'rails_helper'

RSpec.describe 'Announcements' do
  describe 'GET /announcements' do
    subject! { get '/announcements' }

    it { expect(response).to have_http_status :redirect }
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/announcements" do
      subject(:action) { get "/#{locale}/announcements" }

      before do
        create :announcement, locale: locale
        action
      end

      it { expect(response).to have_http_status :ok }
    end
  end
end
