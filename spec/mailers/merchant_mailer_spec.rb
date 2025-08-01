require 'rails_helper'

RSpec.describe MerchantMailer do
  before { freeze_time }

  after do
    FileUtils.rm_rf(Rails.root.join('spec/fixtures/files/merchant_mailer'))
  end

  describe '#send_new_merchant' do
    subject(:mail) do
      described_class
        .with(
          data: merchant_proposal.to_osm,
          proposition_from: 'foobar@example.com'
        )
        .send_new_merchant
    end

    let(:merchant_proposal) do
      build :merchant_proposal,
            name: 'Great merchant XMR',
            proposition_from: 'foobar@example.com'
    end

    it 'renders the headers', :aggregate_failures do
      expect(mail.subject).to eq I18n.t('merchant_mailer.send_new_merchant.subject')
      expect(mail.to).to eq(['sortiedebanque@tutamail.com'])
      expect(mail.from).to eq(['no-reply@bank-exit.org'])
      expect(mail.reply_to).to eq(['foobar@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(/Great merchant XMR/)
    end
  end

  describe '#send_report_merchant' do
    subject(:mail) do
      described_class
        .with(merchant: merchant, description: description)
        .send_report_merchant
    end

    let(:merchant) { create :merchant }
    let(:description) { 'Lorem ispum error on coins' }

    it 'renders the headers', :aggregate_failures do
      expect(mail.subject).to eq I18n.t('merchant_mailer.send_report_merchant.subject')
      expect(mail.to).to eq(['sortiedebanque@tutamail.com'])
      expect(mail.from).to eq(['no-reply@bank-exit.org'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(/Lorem ispum error on coins/)
    end

    it 'creates a TXT file of the mail' do
      mail.subject

      filepath = Rails.root.join("spec/fixtures/files/merchant_mailer/#{Time.current.to_fs(:number)}_send_report_merchant.txt")

      expect(File).to exist(filepath)
    end
  end
end
