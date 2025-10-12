require 'rails_helper'

RSpec.shared_examples 'a commentable API' do
  context 'when comments are requested' do
    let(:args) { { view: :with_comments } }

    context 'without comments' do
      it 'returns an empty comments array' do
        expect(json).to include(comments: [])
      end
    end

    context 'with comments' do
      before do
        create :comment,
               content: 'This is a test comment for validation.',
               rating: 2,
               language: 'en',
               commentable: commentable

        create :comment, :flagged, commentable: commentable

        # Comment linked to another unrelated record
        create :comment
      end

      it 'includes only visible comments for the record' do
        expect(json[:comments]).to contain_exactly(
          content: 'This is a test comment for validation.',
          language: 'en',
          rating: 2
        )
      end
    end
  end
end
