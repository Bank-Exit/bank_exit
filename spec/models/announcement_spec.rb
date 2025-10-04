require 'rails_helper'

RSpec.describe Announcement do
  it { is_expected.to validate_presence_of(:title_en) }
  it { is_expected.to validate_presence_of(:description_en) }

  it {
    expect(described_class.new).to define_enum_for(:mode)
      .with_values(default: 0, info: 1, success: 2, warning: 3, error: 4)
      .backed_by_column_of_type(:integer)
  }

  it { is_expected.to validate_content_type_of(:picture).allowing('image/png', 'image/jpeg') }
  it { is_expected.to validate_size_of(:picture).less_than(1.megabyte) }

  describe '.enabled' do
    let!(:enabled_announcement) { create(:announcement, enabled: true) }
    let!(:disabled_announcement) { create(:announcement, enabled: false) }

    it 'returns only enabled announcements', :aggregate_failures do
      result = described_class.enabled

      expect(result).to include(enabled_announcement)
      expect(result).to_not include(disabled_announcement)
    end
  end

  describe '.published' do
    let!(:published) do
      create(:announcement, published_at: 1.day.ago, unpublished_at: 1.day.from_now)
    end
    let!(:not_yet_published) { create(:announcement, published_at: 1.day.from_now) }
    let!(:already_unpublished) { create(:announcement, unpublished_at: 1.day.ago) }

    it 'returns only currently published announcements', :aggregate_failures do
      result = described_class.published

      expect(result).to include(published)
      expect(result).to_not include(not_yet_published)
      expect(result).to_not include(already_unpublished)
    end
  end

  describe '#overpass?' do
    subject(:announcement) { build(:announcement, unpublished_at: unpublished_at) }

    context 'when unpublished_at is in the past' do
      let(:unpublished_at) { 1.day.ago }

      it { expect(announcement.overpass?).to be true }
    end

    context 'when unpublished_at is in the future' do
      let(:unpublished_at) { 1.day.from_now }

      it { expect(announcement.overpass?).to be false }
    end

    context 'when unpublished_at is nil' do
      let(:unpublished_at) { nil }

      it { expect(announcement.overpass?).to be false }
    end
  end
end
