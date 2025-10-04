require 'rails_helper'

RSpec.describe Directory do
  let(:allowed_categories) do
    I18n.t('directories_categories').keys.map(&:to_s)
  end

  it { is_expected.to validate_presence_of(:name_en) }
  it { is_expected.to validate_presence_of(:description_en) }
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
  end

  describe '.by_query' do
    subject { described_class.by_query(query) }

    before do
      create :directory, name_en: 'Jane Doe name'
      create :directory, description_en: 'Jane Doe description'
    end

    context 'when query matches records' do
      let(:query) { 'john' }

      let!(:directory_with_name) { create :directory, name_en: 'It is John Doe' }
      let!(:directory_with_description) { create :directory, description_en: 'Here is John Doe description' }

      it { is_expected.to contain_exactly(directory_with_name, directory_with_description) }
    end

    context 'when query does not match records' do
      let(:query) { 'nothing to return' }

      it { is_expected.to be_empty }
    end
  end
end
