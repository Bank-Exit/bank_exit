require 'rails_helper'

RSpec.describe SocialUrlPrefixer do
  describe '.call' do
    subject { described_class.call(platform, value) }

    context 'when the value is blank' do
      let(:platform) { 'facebook' }
      let(:value) { '' }

      it { is_expected.to be_nil }
    end

    context 'when the input is a handle' do
      let(:value) { '@osm' }

      {
        'facebook' => 'https://facebook.com/osm',
        'x' => 'https://x.com/osm',
        'instagram' => 'https://instagram.com/osm',
        'youtube' => 'https://youtube.com/osm',
        'tiktok' => 'https://tiktok.com/@osm',
        'telegram' => 'https://t.me/osm',
        'matrix' => 'https://matrix.to/#/osm',
        'linkedin' => 'https://linkedin.com/in/osm',
        'tripadvisor' => 'https://tripadvisor.com/Profile/osm',
        'odysee' => 'https://odysee.com/@osm',
        'crowdbunker' => 'https://crowdbunker.com/@osm',
        'francelibretv' => 'https://francelibre.tv/@osm',
        'nostr' => 'https://njump.to/osm'
      }.each do |platform_name, expected|
        context "with #{platform_name}" do
          let(:platform) { platform_name }

          it { is_expected.to eq(expected) }
        end
      end
    end

    describe '[signal]' do
      let(:platform) { 'signal' }
      let(:value) { '+33612345678?utm_campaign=test' }

      it { is_expected.to eq('+33612345678') }
    end

    describe '[session]' do
      let(:platform) { 'session' }
      let(:value) { 'ABCD1234KEY?utm_source=google' }

      it { is_expected.to eq('ABCD1234KEY') }
    end

    describe '[matrix]' do
      let(:platform) { 'matrix' }
      let(:value) { 'escape_the_matrix?utm_source=google' }

      it { is_expected.to eq('https://matrix.to/#/escape_the_matrix') }
    end

    describe '[unhandled]' do
      let(:platform) { 'unhandled' }
      let(:value) { 'foobar?utm_source=google' }

      it { is_expected.to eq('foobar') }
    end

    context 'when URL has no protocol' do
      let(:platform) { 'instagram' }
      let(:value) { 'instagram.com/osmfr' }

      it { is_expected.to eq('https://instagram.com/osmfr') }
    end

    context 'when URL includes https://' do
      let(:platform) { 'x' }
      let(:value) { 'https://x.com/osmfr' }

      it { is_expected.to eq('https://x.com/osmfr') }
    end

    describe 'tracking parameters cleanup' do
      let(:platform) { 'youtube' }
      let(:value) { 'youtube.com/@osmfr?utm_source=foo&ref=bar' }

      it { is_expected.to eq('https://youtube.com/@osmfr') }
    end

    describe 'facebook profile.php special case' do
      let(:platform) { 'facebook' }

      context 'with id param' do
        let(:value) { 'facebook.com/profile.php?id=42&utm_source=google' }

        it { is_expected.to eq('https://facebook.com/profile.php?id=42') }
      end

      context 'without id param' do
        let(:value) { 'facebook.com/profile.php?utm_source=foo' }

        it { is_expected.to eq('https://facebook.com/profile.php') }
      end
    end

    describe 'twitter to x.com migration' do
      let(:platform) { 'x' }
      let(:value) { 'twitter.com/osmfr' }

      it { is_expected.to eq('https://x.com/osmfr') }
    end

    describe 'youtube and youtu.be normalization' do
      let(:platform) { 'youtube' }

      context 'with youtube.com/watch?v=' do
        let(:value) { 'youtube.com/watch?v=abc123&utm_source=twitter' }

        it { is_expected.to eq('https://youtube.com/watch?v=abc123') }
      end

      context 'with youtu.be short link' do
        let(:value) { 'youtu.be/abc123?utm_campaign=foo' }

        it { is_expected.to eq('https://youtu.be/abc123') }
      end
    end
  end

  describe '.url_like?' do
    subject { described_class.url_like?(value) }

    context 'with known social domain' do
      let(:value) { 'facebook.com/osm' }

      it { is_expected.to be true }
    end

    context 'with extra domain (twitter.com)' do
      let(:value) { 'twitter.com/osm' }

      it { is_expected.to be true }
    end

    context 'with unknown domain' do
      let(:value) { 'example.com/osm' }

      it { is_expected.to be false }
    end
  end

  describe '.known_domains' do
    subject(:domains) { described_class.known_domains }

    it 'includes all SOCIAL_PREFIXES and EXTRA_DOMAINS' do
      expect(domains).to include(
        'facebook.com',
        'x.com',
        'youtube.com',
        't.me',
        'linkedin.com',
        'francelibre.tv',
        'twitter.com',
        'youtu.be'
      )
    end
  end
end
