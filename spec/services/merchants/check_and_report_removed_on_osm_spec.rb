require 'rails_helper'

RSpec.describe Merchants::CheckAndReportRemovedOnOSM do
  describe '#call' do
    subject(:call) { described_class.call(merchant_ids) }

    let!(:merchant) do
      create :merchant, monero: true, name: 'John Monero', identifier: '111111', country: 'FR'
    end

    before do
      freeze_time
    end

    context 'when all data are matching' do
      let(:merchant_ids) { ['node/111111', 'node/3456789'] }

      before do
        stub_request(:patch, /api.github.com/)
          .with(body: {
            body: <<~MARKDOWN
              There are no Monero/June merchants disabled for now 🎉

              ---

              *Note: this issue has been automatically updated from bank-exit website using the Github API.*
            MARKDOWN
          }.to_json)
          .to_return_json(status: 200)
      end

      it { expect { call }.to_not raise_error }
    end

    context 'when merchant ids is present' do
      let(:merchant_ids) { %w[node/123 node/456 node/789] }

      before do
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

      it { expect(merchant).to be_soft_deleted }
    end
  end
end
