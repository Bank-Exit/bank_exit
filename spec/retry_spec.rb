require 'spec_helper'

# rubocop:disable Lint/SuppressedException
RSpec.describe Retry do
  describe '.on' do
    context 'when no exception happens' do
      it 'runs' do
        retries = 0
        described_class.on(StandardError, times: 3) do
          retries += 1
        end
        expect(retries).to eq 1
      end
    end

    context 'when a different exception happens' do
      it 'runs' do
        custom_error = Class.new(StandardError)

        retries = 0
        begin
          described_class.on(custom_error, times: 3) do
            retries += 1
            raise "Raising number #{time}"
          end
        rescue StandardError
        end
        expect(retries).to eq 1
      end
    end

    context 'when an exception happens' do
      it 'retries several times' do
        retries = 0
        begin
          described_class.on(StandardError, times: 2, waiting_time: 0.3) do |time|
            retries += 1
            raise "Raising number #{time}"
          end
        rescue StandardError
        end
        expect(retries).to eq 2
      end

      it 'raises the exception' do
        custom_error = Class.new(StandardError)
        custom_error_2 = Class.new(StandardError)
        expect do
          described_class.on(custom_error, custom_error_2, times: 3, waiting_time: 0) do |time|
            raise custom_error_2, "Raising number #{time}"
          end
        end
          .to raise_error 'Raising number 2'
      end
    end
  end
end
# rubocop:enable Lint/SuppressedException
