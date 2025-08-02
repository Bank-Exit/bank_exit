require 'rails_helper'

RSpec.describe DirectoryMailer do
  before { freeze_time }

  after do
    FileUtils.rm_rf(Rails.root.join('spec/fixtures/files/directory_mailer'))
  end

  describe '#send_new_directory' do
    subject(:mail) do
      described_class
        .with(
          directory_id: 1,
          proposition_from: proposition_from
        )
        .send_new_directory
    end

    let(:proposition_from) { 'foobar@example.com' }

    context 'when proposition_from is present' do
      it 'renders the headers', :aggregate_failures do
        expect(mail.subject).to eq I18n.t('directory_mailer.send_new_directory.subject')
        expect(mail.to).to eq(['sortiedebanque@tutamail.com'])
        expect(mail.from).to eq(['no-reply@bank-exit.org'])
        expect(mail.reply_to).to eq(['foobar@example.com'])
      end
    end

    context 'when proposition_from is not present' do
      let(:proposition_from) { nil }

      it 'does not specify reply-to header' do
        expect(mail.reply_to).to be_nil
      end
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(%r{admin/directories/1/edit})
    end
  end
end
