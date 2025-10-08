require 'rails_helper'

RSpec.describe ContactWay do
  it { is_expected.to define_enum_for(:role).with_values(described_class.roles.keys) }

  context 'when role is :email' do
    subject { build_stubbed :contact_way, :email }

    it { is_expected.to allow_value('foobar@test.com').for(:value) }
    it { is_expected.to_not allow_values(nil, 'foobar', 'https://foobar.com').for(:value) }
  end

  context 'when role is :website' do
    subject { build_stubbed :contact_way, :website }

    it { is_expected.to allow_value('https://foobar.com', 'http://foobar.com', 'foobar.com', 'foobar.com/index.html', 'foobar.finance').for(:value) }
    it { is_expected.to_not allow_values(nil, 'foobar', 'foobar@test.com').for(:value) }
  end

  context 'when role is :simplex' do
    subject { build_stubbed :contact_way, :simplex }

    it { is_expected.to allow_values('123456', 'https://simplex.chat/123456').for(:value) }
  end
end
