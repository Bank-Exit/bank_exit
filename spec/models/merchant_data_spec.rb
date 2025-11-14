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
        website: 'https://foobar.com/',
        'contact:facebook': 'https://facebook.com/profile.php?id=foobar'
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

  let(:twicked_feature) { feature }

  it { is_expected.to include(contact_facebook: 'https://facebook.com/profile.php?id=foobar') }
  it { is_expected.to include(contact_instagram: nil, contact_tiktok: nil, contact_session: nil) }

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

  describe '#website' do
    context 'when [website] is present' do
      let(:twicked_feature) do
        feature[:properties]['website'] = 'https://mywebsite.com'
        feature
      end

      it { is_expected.to include(website: 'https://mywebsite.com') }

      context 'when a GET params is present in the URL' do
        let(:twicked_feature) do
          feature[:properties]['website'] = 'https://mywebsite.com/foobar?foo=bar'
          feature
        end

        it { is_expected.to include(website: 'https://mywebsite.com/foobar') }
      end
    end

    context 'when [website] is missing' do
      let(:twicked_feature) do
        feature[:properties].delete(:website)
        feature
      end

      it { is_expected.to include(website: nil) }
    end

    context 'when [contact:website] is present' do
      let(:twicked_feature) do
        feature[:properties].delete(:website)
        feature[:properties]['contact:website'] = 'https://mywebsite.com'
        feature
      end

      it { is_expected.to include(website: 'https://mywebsite.com') }

      context 'when a GET params is present in the URL' do
        let(:twicked_feature) do
          feature[:properties].delete(:website)
          feature[:properties]['contact:website'] = 'https://mywebsite.com/foobar?foo=bar'
          feature
        end

        it { is_expected.to include(website: 'https://mywebsite.com/foobar') }
      end
    end

    context 'when [contact:website] is missing' do
      let(:twicked_feature) do
        feature[:properties].delete(:website)
        feature[:properties].delete(:'contact:website')
        feature
      end

      it { is_expected.to include(website: nil) }
    end
  end

  describe '#phone' do
    context 'when no phone key is present' do
      let(:twicked_feature) do
        feature[:properties].delete(:phone)
        feature
      end

      it { is_expected.to include(phone: nil) }
    end

    context 'when only one number is present' do
      let(:twicked_feature) do
        feature[:properties]['phone'] = '+1234567890'
        feature
      end

      it { is_expected.to include(phone: '+1234567890') }
    end

    context 'when multiple phone numbers are present in same key' do
      let(:twicked_feature) do
        feature[:properties]['phone'] = '+1234567890;+0987654321'
        feature
      end

      it { is_expected.to include(phone: '+1234567890') }
    end

    context 'when phone numbers are present in multiple keys' do
      let(:twicked_feature) do
        feature[:properties]['phone'] = '+1234567890'
        feature[:properties]['mobile'] = '+0987654321'
        feature
      end

      it { is_expected.to include(phone: '+1234567890') }
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

  describe '#ask_kyc' do
    context 'when [payment:kyc] is yes' do
      let(:twicked_feature) do
        feature[:properties]['payment:kyc'] = 'yes'
        feature
      end

      it { is_expected.to include(ask_kyc: true) }
    end

    context 'when [payment:kyc] is no' do
      let(:twicked_feature) do
        feature[:properties]['payment:kyc'] = 'no'
        feature
      end

      it { is_expected.to include(ask_kyc: false) }
    end

    context 'when [payment:kyc] is not set' do
      let(:twicked_feature) do
        feature[:properties].delete(:'payment:kyc')
        feature
      end

      it { is_expected.to include(ask_kyc: nil) }
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

      context 'when [payment:onchain] is no' do
        let(:twicked_feature) do
          feature[:properties]['payment:onchain'] = 'no'
          feature
        end

        it { is_expected.to include(coins: %w[]) }
        it { is_expected.to include(bitcoin: false) }
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
