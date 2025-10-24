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

  describe '#christmas_time?' do
    subject { christmas_time?(force: force_snowflakes) }

    let(:force_snowflakes) { false }

    before do
      allow(ENV)
        .to receive(:fetch)
        .with('FF_SNOWFLAKES_ENABLED', 'true') { ff_snowflakes_enabled }

      travel_to date
    end

    context 'when force params is true' do
      let(:force_snowflakes) { true }
      let(:ff_snowflakes_enabled) { 'false' }
      let(:date) { Date.new(2025, 12, 1) } # December 1st

      it { is_expected.to be true }
    end

    context 'when FF_SNOWFLAKES_ENABLED ENV is false' do
      let(:ff_snowflakes_enabled) { 'false' }

      context 'when before Christmas time' do
        let(:date) { Date.new(2025, 12, 1) } # December 1st

        it { is_expected.to be false }
      end

      context 'when during Christmas time' do
        let(:date) { Date.new(2025, 12, 25) } # December 25

        it { is_expected.to be false }
      end

      context 'when after Christmas time' do
        let(:date) { Date.new(2026, 1, 8) } # January 8

        it { is_expected.to be false }
      end
    end

    context 'when FF_SNOWFLAKES_ENABLED ENV is true' do
      let(:ff_snowflakes_enabled) { 'true' }

      context 'when before Christmas time' do
        let(:date) { Date.new(2025, 12, 1) } # December 1st

        it { is_expected.to be false }
      end

      context 'when during Christmas time' do
        let(:date) { Date.new(2025, 12, 25) } # December 25

        it { is_expected.to be true }
      end

      context 'when during new year time' do
        let(:date) { Date.new(2026, 1, 2) } # January 2nd

        it { is_expected.to be true }
      end

      context 'when after Christmas time' do
        let(:date) { Date.new(2026, 1, 20) } # January 20

        it { is_expected.to be false }
      end
    end
  end

  describe '#halloween_time?' do
    subject { halloween_time?(force: force_halloween) }

    let(:force_halloween) { false }

    before do
      travel_to date
    end

    context 'when force params is true' do
      let(:force_halloween) { true }
      let(:date) { Date.new(2025, 12, 1) } # December 1st

      it { is_expected.to be true }
    end

    context 'when before halloween time' do
      let(:date) { Date.new(2025, 10, 1) } # October 1st

      it { is_expected.to be false }
    end

    context 'when halloween eve time' do
      let(:date) { Date.new(2025, 10, 30) } # October 30

      it { is_expected.to be true }
    end

    context 'when halloween time' do
      let(:date) { Date.new(2025, 10, 31) } # October 31

      it { is_expected.to be true }
    end

    context 'when after halloween time' do
      let(:date) { Date.new(2025, 11, 2) } # November 2nd

      it { is_expected.to be false }
    end
  end
end
