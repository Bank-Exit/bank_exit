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

  describe 'GET /stats/daily_merchants' do
    subject! { get '/stats/daily_merchants', params: params }

    let(:params) { { date: date } }

    context 'when date is valid' do
      let(:date) { Date.current.to_s }

      it { expect(response).to have_http_status :redirect }
    end

    context 'when date is invalid' do
      let(:date) { 'fake' }

      it { expect(response).to have_http_status :redirect }
    end

    context 'when date is missing' do
      let(:params) { {} }

      it { expect(response).to have_http_status :redirect }
    end
  end

  describe 'POST /statistics/toggle_atms' do
    subject! { post '/statistics/toggle_atms' }

    let(:params) { { include_atms: true } }

    it { expect(response).to have_http_status :ok }
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/stats" do
      subject! { get "/#{locale}/stats" }

      context 'when created_on is not present' do
        let(:created_on) { nil }

        it { expect(response).to have_http_status :ok }
      end

      context 'when created_on is present' do
        context 'when created_on is valid date in the past' do
          let(:created_on) { 3.days.ago.to_date }

          it { expect(response).to have_http_status :ok }
        end

        context 'when created_on is valid date in the future' do
          let(:created_on) { 3.days.from_now.to_date }

          it { expect(response).to have_http_status :ok }
        end

        context 'when created_on is invalid date' do
          let(:created_on) { 'fake' }

          it { expect(response).to have_http_status :ok }
        end
      end
    end

    describe "GET /#{locale}/stats/daily_merchants" do
      subject! { get "/#{locale}/stats/daily_merchants", params: params }

      let(:params) { { date: date } }

      context 'when date is valid' do
        let(:date) { Date.current.to_s }

        it { expect(response).to have_http_status :ok }
      end

      context 'when date is futur' do
        let(:date) { 3.days.from_now.to_date }

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
end
