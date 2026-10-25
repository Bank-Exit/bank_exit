require 'rails_helper'

RSpec.describe ApplicationHelper do
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

    context 'when URL has invalid UTF-8 encoding' do
      let(:url) { "https://www.facebook.com/ขนมจีนสด-กู่ทอง-อร่อยที่สุด\xE0" }

      it { is_expected.to be_nil }
    end
  end
end
