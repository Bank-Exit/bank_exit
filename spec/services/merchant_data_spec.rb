require 'rails_helper'

RSpec.describe MerchantData do
  subject(:json) { described_class.new(twicked_feature.as_json).json }

  let(:feature) do
    {
      type: 'Feature',
      id: 'node/123456789',
      properties: {
        'currency:XBT': 'yes',
        name: 'Foobar',
        'payment:lightning': 'yes',
        'payment:lightning_contactless': 'yes',
        'payment:onchain': 'yes',
        phone: '+331234567890',
        shop: 'jewelry',
        source: 'foobar',
        'survey:date': '2024-07-23',
        website: 'https://foobar.com/'
      },
      geometry: {
        type: 'Point',
        coordinates: [
          1.1111111,
          48.48484848
        ]
      }
    }
  end

  describe '#name' do
    context 'when [name] is present' do
      let(:twicked_feature) do
        feature[:properties]['name'] = 'John Doe'
        feature
      end

      it { is_expected.to include(name: 'John Doe') }
    end

    context 'when [name] is missing but [brand] is present' do
      let(:twicked_feature) do
        feature[:properties].delete(:name)
        feature[:properties]['brand'] = 'MYBRAND'
        feature
      end

      it { is_expected.to include(name: 'MYBRAND') }
    end

    context 'when [name] and [brand] are missing' do
      let(:twicked_feature) do
        feature[:properties].delete(:name)
        feature[:properties].delete(:brand)
        feature
      end

      it { is_expected.to include(name: 'node/123456789') }
    end
  end

  describe '#country' do
    context 'when [addr:country] is present' do
      let(:twicked_feature) do
        feature[:properties]['addr:country'] = 'France'
        feature
      end

      it { is_expected.to_not include(:country) }
    end

    context 'when [contact:country] is present' do
      let(:twicked_feature) do
        feature[:properties]['contact:country'] = 'France'
        feature
      end

      it { is_expected.to_not include(:country) }
    end

    context 'when [*:country] is not present' do
      let(:twicked_feature) { feature }

      it { is_expected.to_not include(:country) }
    end
  end

  describe '#street' do
    context 'when [addr:street] is present' do
      let(:twicked_feature) do
        feature[:properties]['addr:street'] = 'Liberty Street'
        feature
      end

      it { is_expected.to include(street: 'Liberty Street') }
    end

    context 'when [contact:street] is present' do
      let(:twicked_feature) do
        feature[:properties]['contact:street'] = 'Liberty Street'
        feature
      end

      it { is_expected.to include(street: 'Liberty Street') }
    end

    context 'when [addr:place] is present' do
      let(:twicked_feature) do
        feature[:properties]['addr:place'] = 'Liberty Street'
        feature
      end

      it { is_expected.to include(street: 'Liberty Street') }
    end

    context 'when [*:street] is not present' do
      let(:twicked_feature) { feature }

      it { is_expected.to include(street: nil) }
    end
  end

  describe '[contact:telegram]' do
    context 'when [contact:telegram] is missing' do
      let(:twicked_feature) { feature }

      it { is_expected.to include(contact_telegram: nil) }
    end

    context 'when [contact:telegram] is an absolute link' do
      let(:twicked_feature) do
        feature[:properties]['contact:telegram'] = 'https://t.me/foobar'
        feature
      end

      it { is_expected.to include(contact_telegram: 'https://t.me/foobar') }
    end

    context 'when [contact:telegram] is a relative @link' do
      let(:twicked_feature) do
        feature[:properties]['contact:telegram'] = '@foobar'
        feature
      end

      it { is_expected.to include(contact_telegram: 'https://t.me/foobar') }
    end
  end

  describe '[contact:facebook]' do
    context 'when [contact:facebook] is missing' do
      let(:twicked_feature) { feature }

      it { is_expected.to include(contact_facebook: nil) }
    end

    context 'when [contact:facebook] is an absolute link' do
      let(:twicked_feature) do
        feature[:properties]['contact:facebook'] = 'https://facebook.com/foobar'
        feature
      end

      it { is_expected.to include(contact_facebook: 'https://facebook.com/foobar') }
    end

    context 'when [contact:facebook] is a relative @link' do
      let(:twicked_feature) do
        feature[:properties]['contact:facebook'] = '@foobar'
        feature
      end

      it { is_expected.to include(contact_facebook: 'https://facebook.com/foobar') }
    end
  end

  describe '[contact:instagram]' do
    context 'when [contact:instagram] is missing' do
      let(:twicked_feature) { feature }

      it { is_expected.to include(contact_instagram: nil) }
    end

    context 'when [contact:instagram] is an absolute link' do
      let(:twicked_feature) do
        feature[:properties]['contact:instagram'] = 'https://instagram.com/foobar'
        feature
      end

      it { is_expected.to include(contact_instagram: 'https://instagram.com/foobar') }
    end

    context 'when [contact:instagram] is a relative @link' do
      let(:twicked_feature) do
        feature[:properties]['contact:instagram'] = '@foobar'
        feature
      end

      it { is_expected.to include(contact_instagram: 'https://instagram.com/foobar') }
    end
  end

  describe '[contact:twitter]' do
    context 'when [contact:twitter] is missing' do
      let(:twicked_feature) { feature }

      it { is_expected.to include(contact_twitter: nil) }
    end

    context 'when [contact:twitter] is an absolute link with twitter.com' do
      let(:twicked_feature) do
        feature[:properties]['contact:twitter'] = 'https://twitter.com/foobar'
        feature
      end

      it { is_expected.to include(contact_twitter: 'https://twitter.com/foobar') }
    end

    context 'when [contact:twitter] is an absolute link with x.com' do
      let(:twicked_feature) do
        feature[:properties]['contact:twitter'] = 'https://x.com/foobar'
        feature
      end

      it { is_expected.to include(contact_twitter: 'https://x.com/foobar') }
    end

    context 'when [contact:twitter] is a relative @link' do
      let(:twicked_feature) do
        feature[:properties]['contact:twitter'] = '@foobar'
        feature
      end

      it { is_expected.to include(contact_twitter: 'https://x.com/foobar') }
    end
  end

  describe '[contact:youtube]' do
    context 'when [contact:youtube] is missing' do
      let(:twicked_feature) { feature }

      it { is_expected.to include(contact_youtube: nil) }
    end

    context 'when [contact:youtube] is an absolute link' do
      let(:twicked_feature) do
        feature[:properties]['contact:youtube'] = 'https://youtube.com/foobar'
        feature
      end

      it { is_expected.to include(contact_youtube: 'https://youtube.com/foobar') }
    end

    context 'when [contact:youtube] is a relative @link' do
      let(:twicked_feature) do
        feature[:properties]['contact:youtube'] = '@foobar'
        feature
      end

      it { is_expected.to include(contact_youtube: 'https://youtube.com/foobar') }
    end
  end

  describe '[contact:tiktok]' do
    context 'when [contact:tiktok] is missing' do
      let(:twicked_feature) { feature }

      it { is_expected.to include(contact_tiktok: nil) }
    end

    context 'when [contact:tiktok] is an absolute link' do
      let(:twicked_feature) do
        feature[:properties]['contact:tiktok'] = 'https://tiktok.com/foobar'
        feature
      end

      it { is_expected.to include(contact_tiktok: 'https://tiktok.com/foobar') }
    end

    context 'when [contact:tiktok] is a relative @link' do
      let(:twicked_feature) do
        feature[:properties]['contact:tiktok'] = '@foobar'
        feature
      end

      it { is_expected.to include(contact_tiktok: 'https://tiktok.com/foobar') }
    end
  end

  describe '[contact:linkedin]' do
    context 'when [contact:linkedin] is missing' do
      let(:twicked_feature) { feature }

      it { is_expected.to include(contact_linkedin: nil) }
    end

    context 'when [contact:linkedin] is an absolute link' do
      let(:twicked_feature) do
        feature[:properties]['contact:linkedin'] = 'https://linkedin.com/foobar'
        feature
      end

      it { is_expected.to include(contact_linkedin: 'https://linkedin.com/foobar') }
    end

    context 'when [contact:linkedin] is a relative @link' do
      let(:twicked_feature) do
        feature[:properties]['contact:linkedin'] = '@foobar'
        feature
      end

      it { is_expected.to include(contact_linkedin: 'https://linkedin.com/foobar') }
    end
  end

  describe '[contact:tripadvisor]' do
    context 'when [contact:tripadvisor] is missing' do
      let(:twicked_feature) { feature }

      it { is_expected.to include(contact_tripadvisor: nil) }
    end

    context 'when [contact:tripadvisor] is an absolute link' do
      let(:twicked_feature) do
        feature[:properties]['contact:tripadvisor'] = 'https://tripadvisor.com/foobar'
        feature
      end

      it { is_expected.to include(contact_tripadvisor: 'https://tripadvisor.com/foobar') }
    end

    context 'when [contact:tripadvisor] is a relative @link' do
      let(:twicked_feature) do
        feature[:properties]['contact:tripadvisor'] = '@foobar'
        feature
      end

      it { is_expected.to include(contact_tripadvisor: 'https://tripadvisor.com/foobar') }
    end
  end

  describe '[contact:odysee]' do
    context 'when [contact:odysee] is missing' do
      let(:twicked_feature) { feature }

      it { is_expected.to include(contact_odysee: nil) }
    end

    context 'when [contact:odysee] is an absolute link' do
      let(:twicked_feature) do
        feature[:properties]['contact:odysee'] = 'https://odysee.com/foobar'
        feature
      end

      it { is_expected.to include(contact_odysee: 'https://odysee.com/foobar') }
    end

    context 'when [contact:odysee] is a relative @link' do
      let(:twicked_feature) do
        feature[:properties]['contact:odysee'] = '@foobar'
        feature
      end

      it { is_expected.to include(contact_odysee: 'https://odysee.com/foobar') }
    end
  end

  describe '[contact:crowdbunker]' do
    context 'when [contact:crowdbunker] is missing' do
      let(:twicked_feature) { feature }

      it { is_expected.to include(contact_crowdbunker: nil) }
    end

    context 'when [contact:crowdbunker] is an absolute link' do
      let(:twicked_feature) do
        feature[:properties]['contact:crowdbunker'] = 'https://crowdbunker.com/@foobar'
        feature
      end

      it { is_expected.to include(contact_crowdbunker: 'https://crowdbunker.com/@foobar') }
    end

    context 'when [contact:crowdbunker] is a relative @link' do
      let(:twicked_feature) do
        feature[:properties]['contact:crowdbunker'] = '@foobar'
        feature
      end

      it { is_expected.to include(contact_crowdbunker: 'https://crowdbunker.com/@foobar') }
    end
  end

  describe '[contact:francelibretv]' do
    context 'when [contact:francelibretv] is missing' do
      let(:twicked_feature) { feature }

      it { is_expected.to include(contact_francelibretv: nil) }
    end

    context 'when [contact:francelibretv] is an absolute link' do
      let(:twicked_feature) do
        feature[:properties]['contact:francelibretv'] = 'https://francelibre.tv/chaine/foobar'
        feature
      end

      it { is_expected.to include(contact_francelibretv: 'https://francelibre.tv/chaine/foobar') }
    end

    context 'when [contact:francelibretv] is a relative @link' do
      let(:twicked_feature) do
        feature[:properties]['contact:francelibretv'] = '@foobar'
        feature
      end

      it { is_expected.to include(contact_francelibretv: 'https://francelibre.tv/chaine/foobar') }
    end
  end

  describe '#last_survey_on' do
    context 'when no sources are present' do
      let(:twicked_feature) do
        feature[:properties].delete(:'survey:date')
        feature
      end

      it { is_expected.to include(last_survey_on: nil) }
    end

    context 'when multiples sources are present' do
      let(:twicked_feature) do
        feature[:properties]['survey:date'] = '2020-01-01'
        feature[:properties]['survey:date:currency:XMR'] = '2015-11-18'
        feature[:properties]['check_date:currency:XBT'] = '2025-07-20'
        feature
      end

      it { is_expected.to include(last_survey_on: '2025-07-20') }
    end

    context 'when date is in the future' do
      let(:twicked_feature) do
        feature[:properties]['survey:date'] = '2099-01-01'
        feature
      end

      it { is_expected.to include(last_survey_on: nil) }
    end

    context 'when date is not formatted correctly' do
      let(:twicked_feature) do
        feature[:properties]['check_date'] = 'fake'
        feature[:properties]['survey:date'] = '2024-07-23'
        feature
      end

      it { is_expected.to include(last_survey_on: '2024-07-23') }
    end
  end

  describe '#coins' do
    context 'when [currency:XBT] is yes' do
      let(:feature) do
        {
          type: 'Feature',
          id: 'node/123456789',
          properties: {
            name: 'Foobar',
            'currency:XBT': 'yes'
          },
          geometry: {}
        }
      end

      context 'when no [payment:*] is specified' do
        let(:twicked_feature) { feature }

        it { is_expected.to include(coins: %w[bitcoin]) }
      end

      context 'when [payment:onchain] is yes' do
        let(:twicked_feature) do
          feature[:properties]['payment:onchain'] = 'yes'
          feature
        end

        it { is_expected.to include(coins: %w[bitcoin]) }
        it { is_expected.to include(bitcoin: true) }
      end

      context 'when [payment:lightning] is yes' do
        let(:twicked_feature) do
          feature[:properties]['payment:lightning'] = 'yes'
          feature
        end

        it { is_expected.to include(coins: %w[bitcoin lightning]) }
        it { is_expected.to include(bitcoin: true, lightning: true) }
      end

      context 'when [payment:lightning_contactless] is yes' do
        let(:twicked_feature) do
          feature[:properties]['payment:lightning_contactless'] = 'yes'
          feature
        end

        it { is_expected.to include(coins: %w[bitcoin lightning_contactless]) }
        it { is_expected.to include(bitcoin: true, contact_less: true) }
      end
    end

    context 'when [currency:XBT] is no' do
      let(:feature) do
        {
          type: 'Feature',
          id: 'node/123456789',
          properties: {
            name: 'Foobar',
            'currency:XBT': 'no'
          },
          geometry: {}
        }
      end

      context 'when [payment:onchain] is yes' do
        let(:twicked_feature) do
          feature[:properties]['payment:onchain'] = 'yes'
          feature
        end

        it { is_expected.to include(coins: %w[bitcoin]) }
        it { is_expected.to include(bitcoin: true) }
      end

      context 'when [payment:lightning] is yes' do
        let(:twicked_feature) do
          feature[:properties]['payment:lightning'] = 'yes'
          feature
        end

        it { is_expected.to include(coins: %w[lightning]) }
        it { is_expected.to include(lightning: true) }
      end

      context 'when [payment:lightning_contactless] is yes' do
        let(:twicked_feature) do
          feature[:properties]['payment:lightning_contactless'] = 'yes'
          feature
        end

        it { is_expected.to include(coins: %w[lightning_contactless]) }
        it { is_expected.to include(contact_less: true) }
      end
    end
  end
end
