require 'rails_helper'

RSpec.describe MerchantProposal do
  let(:allowed_categories) do
    I18n.t('categories').keys.push(:other).map(&:to_s)
  end
  let(:allowed_coins) { described_class::ALLOWED_COINS.map(&:to_s) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:street) }
  it { is_expected.to validate_presence_of(:postcode) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:country) }
  it { is_expected.to validate_presence_of(:category) }
  it { is_expected.to allow_values(*allowed_categories).for(:category) }
  it { is_expected.to validate_presence_of(:coins) }
  it { is_expected.to allow_values(*allowed_coins).for(:coins) }
  it { is_expected.to_not allow_values(nil, '').for(:coins) }
  it { is_expected.to validate_presence_of(:proposition_from).allow_blank }
  it { is_expected.to allow_values(nil, '', 'foobar@demo.com').for(:proposition_from) }
  it { is_expected.to_not allow_value('foobar').for(:proposition_from) }
  it { is_expected.to validate_absence_of(:nickname) }

  context 'when category is :bakery' do
    subject { build_stubbed :merchant_proposal, category: :bakery }

    it { is_expected.to_not validate_presence_of(:other_category) }
  end

  context 'when category is :other' do
    subject { build_stubbed :merchant_proposal, category: :other }

    it { is_expected.to validate_presence_of(:other_category) }
  end
end
