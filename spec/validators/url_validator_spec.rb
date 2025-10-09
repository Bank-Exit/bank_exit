require 'rails_helper'

RSpec.describe UrlValidator do
  subject(:model) { dummy_class.new(website: website) }

  let(:dummy_class) do
    stub_const('DummyUrlModel', Class.new do
      include ActiveModel::Model

      attr_accessor :website

      validates :website, url: true
    end)
  end

  describe 'validations' do
    context 'when website is valid' do
      context 'with http scheme' do
        let(:website) { 'http://example.com' }

        it { is_expected.to be_valid }
      end

      context 'with https scheme' do
        let(:website) { 'https://example.com' }

        it { is_expected.to be_valid }
      end

      context 'without scheme' do
        let(:website) { 'example.com' }

        it { is_expected.to be_valid }
      end
    end

    context 'when website is invalid' do
      shared_examples 'an invalid url' do |url|
        let(:website) { url }

        it 'adds a validation error', :aggregate_failures do
          expect(model).to be_invalid
          expect(model.errors[:website]).to include(I18n.t('errors.messages.invalid_url'))
        end
      end

      it_behaves_like 'an invalid url', 'test@example.com'
      it_behaves_like 'an invalid url', 'http://'
      it_behaves_like 'an invalid url', 'http://localhost'
      it_behaves_like 'an invalid url', 'just some text'
    end

    context 'when website is blank' do
      let(:website) { '' }

      it { is_expected.to be_valid }
    end
  end
end
