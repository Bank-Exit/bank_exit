require 'rails_helper'

RSpec.describe DirectoryBlueprint do
  subject(:json) { described_class.render_as_hash(directory, **args) }

  let(:args) { {} }

  let(:directory) do
    create :directory,
           id: 123_456,
           name: 'FooBar',
           description: 'Lorem ipsum !',
           category: 'health'
  end

  before { freeze_time }

  it 'has correct attributes' do
    expect(json).to eq(
      id: 123_456,
      name: 'FooBar',
      description: 'Lorem ipsum !',
      category: 'health',
      last_survey_on: Time.current.iso8601,
      directory_url: Rails.application.routes.url_helpers.directory_url(directory),
      coins: [],
      contacts: [],
      delivery_zones: []
    )
  end

  context 'with attached logo and banner' do
    let(:directory) { create :directory, :with_logo, :with_banner }

    it { expect(json).to include(:logo_url, :banner_url) }
  end

  context 'with associated coin wallets' do
    before do
      create :coin_wallet, :bitcoin, walletable: directory
      create :coin_wallet, :monero, walletable: directory
      create :coin_wallet, :june, walletable: directory, enabled: false

      # another walletable
      create :coin_wallet, :lightning
    end

    it { expect(json[:coins].count).to eq 2 }

    it { expect(json).to include(coins: [{ name: 'bitcoin', public_address: instance_of(String) }, { name: 'monero', public_address: instance_of(String) }]) }
  end

  context 'with associated contact ways' do
    before do
      create :contact_way, :website, value: 'https://mywebsite.com', contactable: directory
      create :contact_way, :email, value: 'myemail@demo.test', contactable: directory
      create :contact_way, :telegram, value: 'https://t.me/foobar', contactable: directory
      create :contact_way, :facebook, contactable: directory, enabled: false

      # another walletable
      create :contact_way, :matrix
    end

    it { expect(json[:contacts].count).to eq 3 }

    it { expect(json).to include(contacts: [{ name: 'website', value: 'https://mywebsite.com' }, { name: 'email', value: 'myemail@demo.test' }, { name: 'telegram', value: 'https://t.me/foobar' }]) }
  end

  context 'with associated delivery zones' do
    before do
      stub_geocoder_from_fixture!

      create :delivery_zone, :country_japan, deliverable: directory
      create :delivery_zone, :world, deliverable: directory, enabled: false

      # another walletable
      create :delivery_zone, :department_77
    end

    it { expect(json[:delivery_zones].count).to eq 1 }

    it { expect(json).to include(delivery_zones: [{ city_name: nil, continent_code: 'AS', country_code: 'JP', department_code: nil, name: 'country', region_code: nil, value: 'JP' }]) }
  end

  it_behaves_like 'a commentable API' do
    let(:commentable) { directory }
  end
end
