require 'rails_helper'

RSpec.describe 'Tutorials::Reports' do
  let(:identifier) { 'session-messaging' }
  let(:invalid_tutorial_id) { 'fakeID' }

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/tutorials/:id/report/new" do
      subject! do
        get "/#{locale}/tutorials/#{identifier}/report/new", as: :turbo_stream
      end

      context 'when tutorial exists' do
        let(:identifier) { 'session-messaging' }

        it { expect(response).to have_http_status :ok }
      end

      context 'when tutorial does not exist' do
        let(:identifier) { invalid_tutorial_id }

        it { expect(response).to have_http_status :not_found }
      end
    end
  end

  describe 'POST /en/tutorials/:id/report' do
    subject(:action) do
      post "/en/tutorials/#{identifier}/report",
           params: params,
           as: :turbo_stream
    end

    context 'when params are valid' do
      let(:params) do
        { tutorial_report: { title: 'Foo Bar Baz', description: 'Foobar' } }
      end

      context 'when Github API responds successfully' do
        before do
          stub_request(:post, /api.github.com/)
            .with(body: {
              title: 'Foo Bar Baz',
              body: "An anomaly has been identified on the **Private Session messaging** tutorial. Please take a look and fix content accordingly:\n\n> Foobar\n\n---\n\n- Tutorial: http://example.test/en/tutorials/session-messaging\n\n*Note: this issue has been automatically opened from bank-exit website using the Github API.*\n",
              labels: %w[tutorial anomaly english]
            }.to_json)

          action
        end

        it { expect(response).to have_http_status :ok }
        it { expect(flash[:notice]).to eq(I18n.t('tutorials.reports.create.notice')) }
      end

      context 'when Github API raise an error' do
        before do
          stub_request(:post, /api.github.com/)
            .to_return_json(body: { message: 'Foobar error' }, status: 422)

          action
        end

        it { expect(response).to have_http_status :unprocessable_content }
        it { expect(flash[:alert]).to eq('Github API error: Foobar error') }
      end
    end

    context 'when :title is empty' do
      let(:params) do
        { tutorial_report: { title: '', description: 'Foobar' } }
      end

      before { action }

      it { expect(response).to have_http_status :unprocessable_content }
    end

    context 'when :description is empty' do
      let(:params) do
        { tutorial_report: { title: 'Foo Bar', description: '' } }
      end

      before { action }

      it { expect(response).to have_http_status :unprocessable_content }
    end

    context 'when bot make the request' do
      let(:params) do
        { tutorial_report: { title: 'Foo Bar', description: 'Foobar', nickname: 'bot' } }
      end

      before { action }

      it { expect(response).to have_http_status :ok }
      it { expect(flash[:notice]).to eq(I18n.t('tutorials.reports.create.notice')) }
    end
  end
end
