require 'rails_helper'

RSpec.describe OpeningHoursParser do
  subject { described_class.call(opening_hours) }

  describe 'with english locale' do
    around do |example|
      I18n.with_locale(:en) do
        example.run
      end
    end

    context 'when by_appointment' do
      let(:opening_hours) { '"by appointment"' }

      it { is_expected.to eq ['By appointment'] }
    end

    context 'with multiples rules' do
      let(:opening_hours) { 'Mo-Fr 07:00-21:30; Sa-Su 09:00-22:00' }

      it { is_expected.to eq ['monday to friday from 07:00 to 21:30', 'saturday to sunday from 09:00 to 22:00'] }
    end

    context 'with one uniq rule' do
      let(:opening_hours) { 'Su-Tu 12:00-17:00' }

      it { is_expected.to eq ['sunday to tuesday from 12:00 to 17:00'] }
    end

    context 'with one day' do
      let(:opening_hours) { 'Tu 12:00-17:00' }

      it { is_expected.to eq ['tuesday from 12:00 to 17:00'] }
    end

    context 'with multiple hours range' do
      let(:opening_hours) { 'Mo-We 10:30-23:59; Th-Fr 00:00-01:00, 10:30-23:59; Sa 00:00-01:00' }

      it { is_expected.to eq ['monday to wednesday from 10:30 to 23:59', 'thursday to friday from 00:00 to 01:00 and 10:30 to 23:59', 'saturday from 00:00 to 01:00'] }
    end

    context 'with two hours range' do
      let(:opening_hours) { 'PH,Mo-Fr 10:00-14:00,15:00-19:00; PH off' }

      it { is_expected.to eq ['monday to friday from 10:00 to 14:00 and 15:00 to 19:00'] }
    end

    context 'when data is not properly specified' do
      let(:opening_hours) { 'Mo,Th 10:00-18:00; Tu-Sa 10:00-14:00' }

      it { is_expected.to eq [opening_hours] }
    end

    context 'when data does not contains days or hours' do
      let(:opening_hours) { '24/7' }

      it { is_expected.to eq [opening_hours] }
    end
  end

  describe 'with french locale' do
    around do |example|
      I18n.with_locale(:fr) do
        example.run
      end
    end

    context 'when by_appointment' do
      let(:opening_hours) { '"by appointment"' }

      it { is_expected.to eq ['Sur rendez-vous'] }
    end

    context 'with multiples rules' do
      let(:opening_hours) { 'Mo-Fr 07:00-21:30; Sa-Su 09:00-22:00' }

      it { is_expected.to eq ['lundi à vendredi de 07:00 à 21:30', 'samedi à dimanche de 09:00 à 22:00'] }
    end

    context 'with one uniq rule' do
      let(:opening_hours) { 'Su-Tu 12:00-17:00' }

      it { is_expected.to eq ['dimanche à mardi de 12:00 à 17:00'] }
    end

    context 'with one day' do
      let(:opening_hours) { 'Tu 12:00-17:00' }

      it { is_expected.to eq ['mardi de 12:00 à 17:00'] }
    end

    context 'with multiple hours range' do
      let(:opening_hours) { 'Mo-We 10:30-23:59; Th-Fr 00:00-01:00, 10:30-23:59; Sa 00:00-01:00' }

      it { is_expected.to eq ['lundi à mercredi de 10:30 à 23:59', 'jeudi à vendredi de 00:00 à 01:00 et 10:30 à 23:59', 'samedi de 00:00 à 01:00'] }
    end

    context 'with two hours range' do
      let(:opening_hours) { 'PH,Mo-Fr 10:00-14:00,15:00-19:00; PH off' }

      it { is_expected.to eq ['lundi à vendredi de 10:00 à 14:00 et 15:00 à 19:00'] }
    end

    context 'when data is not properly specified' do
      let(:opening_hours) { 'Mo,Th 10:00-18:00; Tu-Sa 10:00-14:00' }

      it { is_expected.to eq [opening_hours] }
    end

    context 'when data does not contains days or hours' do
      let(:opening_hours) { '24/7' }

      it { is_expected.to eq [opening_hours] }
    end
  end
end
