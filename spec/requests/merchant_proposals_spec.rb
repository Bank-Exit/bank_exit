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
            name: 'Foobar name',
            street: 'Foobar',
            postcode: 'Foobar',
            city: 'Foobar',
            country: 'FR',
            category: 'dentist',
            description: 'Foobar description',
            coins: %w[bitcoin monero],
            contact_odysee: 'https://www.odysee.com/JohnDoe'
          }
        }
      end

      context 'when Github API responds successfully' do
        before do
          stub_request(:post, /api.github.com/)
            .with(body: {
              title: 'Proposal for a new merchant: `Foobar name`',
              body: "A new proposition for a merchant has been submitted. Please take a look and add it to OpenStreetMap if relevant:\n\n```yaml\n---\nname: Foobar name\ncategory: Dentist\nstreet: Foobar\npostcode: Foobar\ncity: Foobar\ncountry: France\ndescription: Foobar description\ncoins:\n- bitcoin\n- monero\nask_kyc: false\ncontact_odysee: https://www.odysee.com/JohnDoe\ndelivery: false\n\n```\n\n---\n\n*Note: this issue has been automatically opened from bank-exit website using the Github API.*\n",
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

        it { expect(response).to have_http_status :unprocessable_entity }
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

        it { expect(response).to have_http_status :unprocessable_entity }
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

        it { expect(response).to have_http_status :unprocessable_entity }
        it { expect(flash[:notice]).to be_nil }
      end
    end
  end
end
