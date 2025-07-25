require 'rails_helper'

RSpec.describe 'Statistics' do
  before do
    create_list :merchant, 3, created_at: Time.current
    create_list :merchant, 2, created_at: 1.day.ago
    create_list :directory, 3
  end

  describe 'GET /stats' do
    subject! { get '/stats' }

    it { expect(response).to redirect_to statistics_en_path }
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/stats" do
      subject! { get '/en/stats' }

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'GET /stats/daily_merchants' do
    subject! { get '/stats/daily_merchants', params: params }

    let(:params) { { query: { date: date } } }

    context 'when date is valid' do
      let(:date) { Date.current.to_s }

      it { expect(response).to have_http_status :ok }
    end

    context 'when date is invalid' do
      let(:date) { 'fake' }

      it { expect(response).to have_http_status :ok }
    end

    context 'when date is missing' do
      let(:params) { {} }

      it { expect(response).to have_http_status :ok }
    end
  end
end
