require 'rails_helper'

RSpec.describe 'MerchantProposals' do
  describe 'GET /merchant_proposals' do
    subject! { get '/merchant_proposals' }

    it { expect(response).to redirect_to new_merchant_proposal_en_path }
  end

  describe 'GET /merchant_proposals/new' do
    subject! { get '/merchant_proposals/new' }

    it { expect(response).to have_http_status :ok }
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/merchant_proposals" do
      subject! { get "/#{locale}/merchant_proposals" }

      it { expect(response).to redirect_to send("new_merchant_proposal_#{locale}_path") }
    end

    describe "GET /#{locale}/merchant_proposals/new" do
      subject! { get "/#{locale}/merchant_proposals/new" }

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'POST /merchant_proposals' do
    subject(:action) { post '/merchant_proposals', params: params }

    context 'when params are valid' do
      let(:params) do
        {
          merchant_proposal: {
            name: 'Bonhomme de Bois',
            street: '1 Toys street',
            postcode: '1234',
            city: 'Toyzz',
            country: 'FR',
            category: 'toys',
            description: "Best toys.\nSolid.\nKids and olders.",
            coins: %w[bitcoin monero],
            contact_odysee: 'https://www.odysee.com/WoodToys'
          }
        }
      end

      context 'when Github API responds successfully' do
        before do
          stub_request(:post, /api.github.com/)
            .with(body: {
              title: 'Proposal for a new merchant: `Bonhomme de Bois`',
              body: <<~MARKDOWN,
                A new proposition for a merchant has been submitted. Please take a look and add it to OpenStreetMap if relevant:

                ```json
                {
                  "name": "Bonhomme de Bois",
                  "category": "Toy",
                  "description": "Best toys. Solid. Kids and olders.",
                  "addr:street": "1 Toys street",
                  "addr:postcode": "1234",
                  "addr:city": "Toyzz",
                  "addr:country": "FR",
                  "currency:XBT": "yes",
                  "payment:onchain": "yes",
                  "currency:XMR": "yes",
                  "payment:kyc": "no",
                  "contact:odysee": "https://www.odysee.com/WoodToys",
                  "_extra_keys": {
                    "country": "🇫🇷 France"
                  }
                }
                ```

                Description:
                ```
                Best toys.
                Solid.
                Kids and olders.
                ```

                ---

                *Note: this issue has been automatically opened from bank-exit website using the Github API.*
              MARKDOWN
              labels: %w[merchant proposal english]
            }.to_json)
        end

        it { expect { action }.to have_enqueued_mail(MerchantMailer, :send_new_merchant) }

        describe '[HTTP status]' do
          before { action }

          it { expect(response).to redirect_to maps_path }
          it { expect(flash[:notice]).to eq(I18n.t('merchant_proposals.create.notice')) }
        end
      end

      context 'when Github API raise an error' do
        before do
          stub_request(:post, /api.github.com/)
            .to_return_json(body: { message: 'Foobar error' }, status: 422)
        end

        it { expect { action }.to_not have_enqueued_mail(MerchantMailer, :send_new_merchant) }

        describe '[HTTP status]' do
          before { action }

          it { expect(response).to redirect_to maps_path }
          it { expect(flash[:alert]).to eq('Github API error: Foobar error') }
        end
      end
    end

    context 'when params are invalid' do
      let(:params) { { merchant_proposal: { name: 'Foobar' } } }

      it { expect { action }.to_not have_enqueued_mail(MerchantMailer, :send_new_merchant) }

      describe '[HTTP status]' do
        before { action }

        it { expect(response).to have_http_status :unprocessable_content }
      end
    end

    context 'when category is :other and #other_category is empty' do
      let(:params) do
        {
          merchant_proposal: {
            name: 'Foobar',
            street: 'Foobar',
            postcode: 'Foobar',
            city: 'Foobar',
            country: 'Foobar',
            category: 'other',
            coins: ['bitcoin']
          }
        }
      end

      it { expect { action }.to_not have_enqueued_mail(MerchantMailer, :send_new_merchant) }

      describe '[HTTP Status]' do
        before { action }

        it { expect(response).to have_http_status :unprocessable_content }
        it { expect(flash[:alert]).to be_nil }
      end
    end

    context 'when captcha is filled' do
      let(:params) do
        {
          merchant_proposal: {
            name: 'Foobar',
            street: 'Foobar',
            postcode: 'Foobar',
            city: 'Foobar',
            country: 'Foobar',
            category: 'dentist',
            coins: ['bitcoin'],
            nickname: 'bot'
          }
        }
      end

      it { expect { action }.to_not have_enqueued_mail(MerchantMailer, :send_new_merchant) }

      describe '[HTTP Status]' do
        before { action }

        it { expect(response).to redirect_to maps_path }
        it { expect(flash[:notice]).to eq(I18n.t('merchant_proposals.create.notice')) }
      end
    end

    context 'when user fills an invalid email' do
      let(:params) do
        {
          merchant_proposal: {
            name: 'Foobar',
            street: 'Foobar',
            postcode: 'Foobar',
            city: 'Foobar',
            country: 'Foobar',
            category: 'dentist',
            coins: ['bitcoin'],
            proposition_from: 'foobar'
          }
        }
      end

      it { expect { action }.to_not have_enqueued_mail(MerchantMailer, :send_new_merchant) }

      describe '[HTTP Status]' do
        before { action }

        it { expect(response).to have_http_status :unprocessable_content }
        it { expect(flash[:notice]).to be_nil }
      end
    end
  end
end
