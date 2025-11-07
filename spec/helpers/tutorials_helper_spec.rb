require 'rails_helper'

RSpec.describe TutorialsHelper do
  describe '#tutorial_class_by_level' do
    subject { helper.tutorial_class_by_level(level) }

    context 'when level is `beginner`' do
      let(:level) { :beginner }

      it { is_expected.to eq :success }
    end

    context 'when level is `intermediate`' do
      let(:level) { :intermediate }

      it { is_expected.to eq :warning }
    end

    context 'when level is `expert`' do
      let(:level) { :expert }

      it { is_expected.to eq :error }
    end

    context 'when level is not handled' do
      let(:level) { :not_handled }

      it { is_expected.to eq :neutral }
    end
  end
end
