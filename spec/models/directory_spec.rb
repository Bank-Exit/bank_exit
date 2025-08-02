require 'rails_helper'

RSpec.describe Directory do
  let(:allowed_categories) do
    I18n.t('directories_categories').keys.map(&:to_s)
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to allow_values(*allowed_categories).for(:category) }
  it { is_expected.to allow_value(nil).for(:category) }
  it { is_expected.to_not allow_value('fake').for(:category) }
  it { is_expected.to validate_content_type_of(:logo).allowing('image/png', 'image/jpeg') }
  it { is_expected.to validate_content_type_of(:banner).allowing('image/png', 'image/jpeg') }
  it { is_expected.to validate_size_of(:logo).less_than(1.megabyte) }
  it { is_expected.to validate_size_of(:banner).less_than(1.megabyte) }

  context 'when directory is proposed' do
    subject { build :directory, requested_by_user: true }

    it { is_expected.to_not allow_value(nil).for(:category) }
    it { is_expected.to validate_presence_of(:description) }
  end
end
