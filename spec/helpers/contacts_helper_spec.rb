require 'rails_helper'

RSpec.describe ContactsHelper, type: :helper do
  describe '#social_contact_icon' do
    subject do
      helper.social_contact_icon(mode, title: title)
    end

    let(:title) { nil }

    context 'when mode is :phone' do
      let(:mode) { :phone }

      context 'when title is present' do
        let(:title) { 'Phone' }

        it { is_expected.to include '<span title="Phone">', '<svg' }
      end

      context 'when title is missing' do
        # it { is_expected.to_not include '<span title="Phone">' }
        it { is_expected.to include '<svg' }
      end
    end

    context 'when mode is :email' do
      let(:mode) { :email }

      context 'when title is present' do
        let(:title) { 'Email' }

        it { is_expected.to include '<span title="Email">', '<svg' }
      end

      context 'when title is missing' do
        # it { is_expected.to_not include '<span title="Email">' }
        it { is_expected.to include '<svg' }
      end
    end

    context 'when mode is :website' do
      let(:mode) { :website }

      context 'when title is present' do
        let(:title) { 'Website' }

        it { is_expected.to include '<span title="Website">', '<svg' }
      end

      context 'when title is missing' do
        # it { is_expected.to_not include '<span title="Website">' }
        it { is_expected.to include '<svg' }
      end
    end

    context 'for :svg images mode' do
      %i[
        session
        signal
        matrix
        jabber
        telegram
        facebook
        instagram
        twitter
        youtube
        odysee
        tiktok
        linkedin
        substack
        nostr
        simplex
        crowdbunker
      ].each do |mode|
        context "when mode is :#{mode}" do
          let(:mode) { mode }

          it { is_expected.to include '<svg', 'fill="currentColor"', '</svg>' }
        end
      end

      context 'when mode is :tripadvisor' do
        let(:mode) { :tripadvisor }

        it { is_expected.to include '<svg', '</svg>' }
      end

      context 'when mode is :francelibretv' do
        let(:mode) { :francelibretv }

        it { is_expected.to include '<svg', '</svg>' }
      end
    end
  end
end
