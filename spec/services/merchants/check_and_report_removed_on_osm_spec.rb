require 'rails_helper'

RSpec.describe Merchants::CheckAndReportRemovedOnOSM do
  describe '#call' do
    subject(:call) { described_class.call(merchant_ids) }

    let(:merchant_ids) { %w[123 456 789] }

    # Extra merchant only in bank-exit map
    let!(:merchant) { create :merchant, name: 'John', identifier: '1234ABCD', country: 'FR' }

    let(:removed_merchants_txt_file) do
      'spec/fixtures/files/merchants/removed_merchants_from_open_street_map.txt'
    end

    before do
      freeze_time

      stub_request(:patch, /api.github.com/)
        .with(body: {
          body: <<~MARKDOWN
            **1** merchants seems to have been removed on OpenStreetMap but are still present in Bank-Exit.org website.
            Please check the relevance of the information below:

            - [ ] **John** [#1234ABCD] 🇫🇷 France
              - Date: #{I18n.l(Time.current)}
              - [On Bank-Exit](http://example.test/en/merchants/1234ABCD-john?debug=true)
              - [On OpenStreetMap](https://www.openstreetmap.org/node/1234ABCD)


            ---

            *Note: this issue has been automatically updated from bank-exit website using the Github API.*
          MARKDOWN
        }.to_json)
        .to_return_json(status: 200)

      call
    end

    after do
      FileUtils.rm_rf(Rails.root.join('spec/fixtures/files/merchants'))
    end

    it { expect(merchant.reload.deleted_at).to_not be_nil }

    it 'creates missing_merchant_ids_from_open_street_map.txt file', :aggregate_failures do
      expect(File).to exist(removed_merchants_txt_file)

      text = File.read(removed_merchants_txt_file)
      expect(text).to match(%r{http://example.test/en/merchants/1234ABCD})
      expect(text).to match(%r{https://www.openstreetmap.org/node/1234ABCD})
    end
  end
end
