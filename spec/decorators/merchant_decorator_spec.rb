require 'rails_helper'

RSpec.describe MerchantDecorator do
  let(:decorator) { merchant.decorate }

  describe '#full_address_with_country' do
    subject do
      decorator.full_address_with_country(
        show_flag: show_flag, expanded: expanded
      )
    end

    let(:merchant) do
      create :merchant,
             house_number: 3, street: 'Square Street',
             postcode: 'ABC123', city: 'MyCity',
             country: 'FR'
    end

    context 'when show_flag is true' do
      let(:show_flag) { true }

      context 'when expanded is true' do
        let(:expanded) { true }

        it { is_expected.to eq '3 Square Street<br />ABC123 MyCity<br />🇫🇷 France' }

        context 'when only country is present' do
          before do
            merchant.house_number = ''
            merchant.street = ''
            merchant.postcode = ''
            merchant.city = ''
          end

          it { is_expected.to eq '🇫🇷 France' }
        end
      end

      context 'when expanded is false' do
        let(:expanded) { false }

        it { is_expected.to eq '3 Square Street ABC123 MyCity<br />🇫🇷 France' }

        context 'when only country is present' do
          before do
            merchant.house_number = ''
            merchant.street = ''
            merchant.postcode = ''
            merchant.city = ''
          end

          it { is_expected.to eq '🇫🇷 France' }
        end
      end
    end

    context 'when show_flag is false' do
      let(:show_flag) { false }

      context 'when expanded is true' do
        let(:expanded) { true }

        it { is_expected.to eq '3 Square Street<br />ABC123 MyCity<br />France' }

        context 'when only country is present' do
          let(:expanded) { false }

          before do
            merchant.house_number = ''
            merchant.street = ''
            merchant.postcode = ''
            merchant.city = ''
          end

          it { is_expected.to eq 'France' }
        end
      end

      context 'when expanded is false' do
        let(:expanded) { false }

        it { is_expected.to eq '3 Square Street ABC123 MyCity<br />France' }

        context 'when only country is present' do
          let(:expanded) { false }

          before do
            merchant.house_number = ''
            merchant.street = ''
            merchant.postcode = ''
            merchant.city = ''
          end

          it { is_expected.to eq 'France' }
        end
      end
    end
  end

  describe '#might_be_outdated?' do
    subject { decorator.might_be_outdated? }

    let(:merchant) { create :merchant, last_survey_on: last_survey_on }

    context 'when #last_survey_on is not defined' do
      let(:last_survey_on) { nil }

      it { is_expected.to be false }
    end

    context 'when #last_survey_on is less than 3 years ago' do
      let(:last_survey_on) { 1.year.ago }

      it { is_expected.to be false }
    end

    context 'when #last_survey_on is more than 3 years ago' do
      let(:last_survey_on) { 5.years.ago }

      it { is_expected.to be true }
    end
  end

  describe '#outdated_level' do
    subject { decorator.outdated_level }

    let(:merchant) { create :merchant, last_survey_on: last_survey_on }

    context 'when #last_survey_on is not defined' do
      let(:last_survey_on) { nil }

      it { is_expected.to eq :unknown }
    end

    context 'when #last_survey_on is between 0 and 2 years ago' do
      let(:last_survey_on) { 1.year.ago }

      it { is_expected.to eq :soft }
    end

    context 'when #last_survey_on is between 2 and 3 years ago' do
      let(:last_survey_on) { 30.months.ago }

      it { is_expected.to eq :medium }
    end

    context 'when #last_survey_on is more than 3 years ago' do
      let(:last_survey_on) { 5.years.ago }

      it { is_expected.to eq :hard }
    end
  end
end
