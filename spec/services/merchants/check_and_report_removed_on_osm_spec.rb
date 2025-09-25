require 'rails_helper'

RSpec.describe Merchants::CheckAndReportRemovedOnOSM do
  describe '#call' do
    subject(:call) { described_class.call(merchant_ids) }

    let(:merchant_ids) { %w[123 456 789] }

    let!(:merchant) do
      create :merchant, monero: true, name: 'John Monero', identifier: '111111', country: 'FR'
    end
    let(:removed_merchants_txt_file) do
      'spec/fixtures/files/merchants/removed_merchants_from_open_street_map.txt'
    end

    before do
      freeze_time

      create :merchant, june: true, name: 'John June', identifier: '222222', country: 'FR'
      create :merchant, bitcoin: true, name: 'John Bitcoin', identifier: '333333', country: 'FR'

      stub_request(:patch, /api.github.com/)
        .with(body: {
          body: <<~MARKDOWN
            **2** Monero and/or June merchants seems to have been removed on OpenStreetMap but are still present in Bank-Exit.org website.
            Please check the relevance of the information below:

            - [ ] **John Monero** [#111111] 🇫🇷 France
              - Date: #{I18n.l(Time.current)}
              - Coins: Monero
              - [On Bank-Exit](http://example.test/en/merchants/111111-john-monero?debug=true)
              - [On OpenStreetMap](https://www.openstreetmap.org/node/111111)

            - [ ] **John June** [#222222] 🇫🇷 France
              - Date: #{I18n.l(Time.current)}
              - Coins: June
              - [On Bank-Exit](http://example.test/en/merchants/222222-john-june?debug=true)
              - [On OpenStreetMap](https://www.openstreetmap.org/node/222222)


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

    it 'creates missing_merchant_ids_from_open_street_map.txt file', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      expect(File).to exist(removed_merchants_txt_file)

      text = File.read(removed_merchants_txt_file)
      expect(text).to match(%r{http://example.test/en/merchants/111111})
      expect(text).to match(%r{https://www.openstreetmap.org/node/111111})
      expect(text).to match(%r{http://example.test/en/merchants/222222})
      expect(text).to match(%r{https://www.openstreetmap.org/node/222222})
    end
  end
end
