require 'rails_helper'

RSpec.describe JSONHighlighter do
  subject(:highlighter) { described_class.new(input).colorize }

  describe '#colorize' do
    context 'when input is a Hash with string values' do
      let(:input) { { 'name' => 'Alice' } }

      it 'highlights keys and strings', :aggregate_failures do
        expect(highlighter).to include('<span class=\'json-key\'>"name"</span>')
        expect(highlighter).to include('<span class=\'json-string\'>"Alice"</span>')
      end
    end

    context 'when input contains numeric values' do
      let(:input) { { 'age' => 42, 'height' => '1.75' } }

      it 'highlights numbers and stringified numbers', :aggregate_failures do
        expect(highlighter).to include('<span class=\'json-number\'>42</span>')
        expect(highlighter).to include('<span class=\'json-number\'>"1.75"</span>')
      end
    end

    context 'when input contains boolean values' do
      let(:input) { { 'active' => true, 'subscribed' => 'false' } }

      it 'highlights booleans and stringified booleans', :aggregate_failures do
        expect(highlighter).to include('<span class=\'json-boolean\'>true</span>')
        expect(highlighter).to include('<span class=\'json-boolean\'>"false"</span>')
      end
    end

    context 'when input contains null values' do
      let(:input) { { 'value' => nil, 'missing' => 'null' } }

      it 'highlights null and stringified null', :aggregate_failures do
        expect(highlighter).to include('<span class=\'json-null\'>null</span>')
        expect(highlighter).to include('<span class=\'json-null\'>"null"</span>')
      end
    end

    context 'when input contains date strings' do
      let(:input) { { 'date1' => '2025-11-03', 'date2' => '2025-11-03T12:34' } }

      it 'highlights date values', :aggregate_failures do
        expect(highlighter).to include('<span class=\'json-date\'>"2025-11-03"</span>')
        expect(highlighter).to include('<span class=\'json-date\'>"2025-11-03T12:34"</span>')
      end
    end

    context 'when input contains arrays' do
      let(:input) { { 'list' => [1, 'two', true, nil] } }

      it 'highlights all elements correctly', :aggregate_failures do
        expect(highlighter).to include('<span class=\'json-number\'>1</span>')
        expect(highlighter).to include('<span class=\'json-string\'>"two"</span>')
        expect(highlighter).to include('<span class=\'json-boolean\'>true</span>')
        expect(highlighter).to include('<span class=\'json-null\'>null</span>')
      end
    end

    context 'when input contains nested hashes' do
      let(:input) { { 'user' => { 'name' => 'Bob', 'age' => 30 } } }

      it 'highlights nested keys and values', :aggregate_failures do
        expect(highlighter).to include('<span class=\'json-key\'>"name"</span>')
        expect(highlighter).to include('<span class=\'json-string\'>"Bob"</span>')
        expect(highlighter).to include('<span class=\'json-key\'>"age"</span>')
        expect(highlighter).to include('<span class=\'json-number\'>30</span>')
      end
    end

    context 'when input is a JSON string' do
      let(:input) { '{"foo": "bar", "num": 5}' }

      it 'parses and highlights the content correctly', :aggregate_failures do
        expect(highlighter).to include('<span class=\'json-key\'>"foo"</span>')
        expect(highlighter).to include('<span class=\'json-string\'>"bar"</span>')
        expect(highlighter).to include('<span class=\'json-key\'>"num"</span>')
        expect(highlighter).to include('<span class=\'json-number\'>5</span>')
      end
    end
  end
end
