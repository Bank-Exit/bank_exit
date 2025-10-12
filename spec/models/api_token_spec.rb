require 'rails_helper'

RSpec.describe APIToken do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:token) }
  it { is_expected.to validate_uniqueness_of(:token) }

  describe '#live?' do
    subject { api_token.live? }

    context 'when API token is not enabled' do
      let(:api_token) { create :api_token, enabled: true, expired_at: 2.days.from_now }

      it { is_expected.to be true }
    end

    context 'when API token is expired' do
      let(:api_token) { create :api_token, expired_at: 2.days.ago, enabled: true }

      it { is_expected.to be false }
    end

    context 'when API token is enabled and expires in the future' do
      let(:api_token) { create :api_token, expired_at: 2.months.from_now, enabled: true }

      it { is_expected.to be true }
    end

    context 'when API token is enabled and does not expire' do
      let(:api_token) { create :api_token, expired_at: nil, enabled: true }

      it { is_expected.to be true }
    end
  end
end
