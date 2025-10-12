require 'rails_helper'

RSpec.describe MerchantBlueprint do
  subject(:json) { described_class.render_as_hash(merchant, **args) }

  let(:args) { {} }

  let(:merchant) do
    create :merchant,
           identifier: '123456',
           name: 'FooBar',
           house_number: '1',
           street: 'Foobar street',
           postcode: '1234',
           city: 'Baz',
           country: 'FR',
           category: 'toys',
           description: 'Lorem ipsum !',
           coins: %w[bitcoin monero],
           contact_odysee: 'https://www.odysee.com/FooBar',
           last_survey_on: '2025-09-25',
           opening_hours: '*',
           website: 'https://foobar.baz',
           email: 'foo@bar.baz',
           phone: '111222333'
  end

  it 'has correct attributes' do
    expect(json).to eq(
      id: '123456',
      name: 'FooBar',
      description: 'Lorem ipsum !',
      category: 'toys',
      coins: %w[bitcoin monero],
      ask_kyc: nil,
      last_survey_on: '2025-09-25',
      opening_hours: '*',
      website: 'https://foobar.baz',
      email: 'foo@bar.baz',
      phone: '111222333',
      merchant_url: Rails.application.routes.url_helpers.merchant_url(merchant),
      address: {
        house_number: '1',
        street: 'Foobar street',
        postcode: '1234',
        city: 'Baz',
        country: 'FR'
      },
      social_contacts: {
        odysee: 'https://www.odysee.com/FooBar'
      }
    )
  end

  context 'with attached logo and banner' do
    let(:merchant) { create :merchant, :with_logo, :with_banner }

    it { expect(json).to include(:logo_url, :banner_url) }
  end

  it_behaves_like 'a commentable API' do
    let(:commentable) { merchant }
  end
end
