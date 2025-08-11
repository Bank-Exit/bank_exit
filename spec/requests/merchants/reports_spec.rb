require 'rails_helper'

RSpec.describe 'Merchants::Reports' do
  let(:merchant) { create :merchant, original_identifier: 'abc123' }
  let(:invalid_merchant_id) { 'fakeID' }

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/merchants/:id/report/new" do
      subject! do
        get "/#{locale}/merchants/#{identifier}/report/new",
            as: :turbo_stream
      end

      context 'when merchant exists' do
        let(:identifier) { merchant.identifier }

        it { expect(response).to have_http_status :ok }
      end

      context 'when merchant does not exist' do
        let(:identifier) { invalid_merchant_id }

        it { expect(response).to have_http_status :not_found }
      end
    end

    describe "POST /#{locale}/merchants/:id/report" do
      subject(:action) do
        post "/#{locale}/merchants/#{merchant.identifier}/report",
             params: params,
             as: :turbo_stream
      end

      context 'when params are valid' do
        let(:params) do
          { merchant_report: { description: 'Foobar' } }
        end

        context 'when Github API responds successfully' do
          before do
            stub_request(:post, /api.github.com/)
              .with(body: {
                title: "Anomaly on merchant: `#{merchant.name}`",
                body: "An anomaly has been identified on the **#{merchant.name}** merchant. Please take a look and update on OpenStreetMap accordingly:\n\n> Foobar\n\n---\n\n- Merchant on Bank-Exit: http://example.test/en/merchants/#{merchant.to_param}\n- Merchant on OpenStreetMap: https://www.openstreetmap.org/abc123\n\n*Note: this issue has been automatically opened from bank-exit website using the Github API.*\n",
                labels: [
                  'merchant',
                  'anomaly',
                  I18n.t(locale, scope: 'languages', locale: :en)
                ]
              }.to_json)
          end

          it { expect { action }.to have_enqueued_mail(MerchantMailer, :send_report_merchant) }

          describe '[HTTP Status]' do
            before { action }

            it { expect(response).to have_http_status :ok }
            it { expect(flash[:notice]).to eq(I18n.t('merchants.reports.create.notice', locale: locale)) }
          end
        end

        context 'when Github API raise an error' do
          before do
            stub_request(:post, /api.github.com/)
              .to_return_json(body: { message: 'Foobar error' }, status: 422)
          end

          it { expect { action }.to_not have_enqueued_mail(MerchantMailer, :send_report_merchant) }

          describe '[HTTP Status]' do
            before { action }

            it { expect(response).to have_http_status :unprocessable_content }
            it { expect(flash[:alert]).to eq('Github API error: Foobar error') }
          end
        end
      end

      context 'when :description is empty' do
        let(:params) { { merchant_report: { description: '' } } }

        it { expect { action }.to_not have_enqueued_mail(MerchantMailer, :send_report_merchant) }

        describe '[HTTP Status]' do
          before { action }

          it { expect(response).to have_http_status :unprocessable_content }
          it { expect(flash[:alert]).to be_nil }
        end
      end

      context 'when bot make the request' do
        let(:params) { { merchant_report: { description: 'Foobar', nickname: 'bot' } } }

        it { expect { action }.to_not have_enqueued_mail(MerchantMailer, :send_report_merchant) }

        describe '[HTTP Status]' do
          before { action }

          it { expect(response).to have_http_status :ok }
          it { expect(flash[:notice]).to eq(I18n.t('merchants.reports.create.notice', locale: locale)) }
        end
      end
    end
  end
end
