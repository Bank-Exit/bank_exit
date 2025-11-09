require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#pretty_country_html' do
    subject { pretty_country_html(country, show_flag: show_flag) }

    let(:country) { 'FR' }
    let(:show_flag) { false }

    it { is_expected.to eq 'France' }

    context 'when show_flag is true' do
      let(:show_flag) { true }

      it { is_expected.to eq '🇫🇷 France' }
    end

    context 'when country is not found' do
      let(:country) { 'Fake' }

      it { is_expected.to eq 'Fake' }
    end
  end

  describe '#clean_url' do
    subject { clean_url(url) }

    context 'when URL starts with http://' do
      let(:url) { 'http://foobar.test' }

      it { is_expected.to eq 'foobar.test' }
    end

    context 'when URL starts with https://' do
      let(:url) { 'https://foobar.test' }

      it { is_expected.to eq 'foobar.test' }
    end

    context 'when URL starts with www.' do
      let(:url) { 'www.foobar.test' }

      it { is_expected.to eq 'foobar.test' }
    end

    context 'when URL starts with http://www.' do
      let(:url) { 'http://www.foobar.test' }

      it { is_expected.to eq 'foobar.test' }
    end

    context 'when URL starts with https://www.' do
      let(:url) { 'https://www.foobar.test' }

      it { is_expected.to eq 'foobar.test' }
    end

    context 'when URL ends with /' do
      let(:url) { 'https://www.foobar.test/' }

      it { is_expected.to eq 'foobar.test' }
    end

    context 'when URL has GET params' do
      let(:url) { 'https://www.foobar.test/?foo=bar' }

      it { is_expected.to eq 'foobar.test' }
    end
  end
end
