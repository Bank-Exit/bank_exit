require 'rails_helper'

RSpec.describe 'Comments' do
  context 'when commentable is merchant' do
    let(:commentable) { create :merchant }

    describe 'GET /merchants/:merchant_id/comments/new' do
      subject! { get "/merchants/#{commentable.identifier}/comments/new", as: :turbo_stream }

      it { expect(response).to have_http_status :redirect }
    end

    I18n.available_locales.each do |locale|
      describe "GET /#{locale}/merchants/:merchant_id/comments/new" do
        subject! do
          get "/#{locale}/merchants/#{commentable.identifier}/comments/new", as: :turbo_stream
        end

        it { expect(response).to have_http_status :ok }
      end

      describe "POST /#{locale}/merchants/:merchant_id/comments" do
        subject(:action) do
          post "/#{locale}/merchants/#{commentable.identifier}/comments",
               params: params, as: :turbo_stream
        end

        context 'when params are valid' do
          let(:params) do
            { comment: { content: 'Foobar', rating: 4, affidavit: '1' } }
          end

          describe '[HTTP status]' do
            before { action }

            it { expect(response).to have_http_status :ok }
            it { expect(flash[:notice]).to eq I18n.t('comments.create.notice', locale: locale) }
          end

          it { expect { action }.to change { Comment.count }.by(1) }
        end

        context 'when acceptance is not checked' do
          let(:params) do
            { comment: { content: 'Foobar', rating: 4 } }
          end

          describe '[HTTP status]' do
            before { action }

            it { expect(response).to have_http_status :unprocessable_content }
          end

          it { expect { action }.to_not change { Comment.count } }
        end

        context 'when acceptance is filled with random value' do
          let(:params) do
            { comment: { content: 'Foobar', rating: 4, affidavit: 'fake' } }
          end

          describe '[HTTP status]' do
            before { action }

            it { expect(response).to have_http_status :ok }
          end

          it { expect { action }.to change { Comment.count }.by(1) }
        end

        context 'when params are invalid' do
          let(:params) {  { comment: { content: '', affidavit: '1' } } }

          describe '[HTTP status]' do
            before { action }

            it { expect(response).to have_http_status :unprocessable_content }
          end

          it { expect { action }.to_not change { Comment.count } }
        end

        context 'when captcha is filled' do
          let(:params) do
            { comment: { content: 'Foobar', rating: 4, nickname: 'bot', affidavit: '1' } }
          end

          describe '[HTTP status]' do
            before { action }

            it { expect(response).to have_http_status :ok }
            it { expect(flash[:notice]).to eq I18n.t('comments.create.notice', locale: locale) }
          end

          it { expect { action }.to_not change { Comment.count } }
        end
      end
    end
  end

  context 'when commentable is directory' do
    let(:commentable) { create :directory }

    describe 'GET /directories/:directory_id/comments/new' do
      subject! { get "/directories/#{commentable.id}/comments/new", as: :turbo_stream }

      it { expect(response).to have_http_status :redirect }
    end

    I18n.available_locales.each do |locale|
      describe "GET /#{locale}/directories/:directory_id/comments/new" do
        subject! do
          get "/#{locale}/directories/#{commentable.id}/comments/new", as: :turbo_stream
        end

        it { expect(response).to have_http_status :ok }
      end

      describe "POST /#{locale}/directories/:directory_id/comments" do
        subject(:action) do
          post "/#{locale}/directories/#{commentable.id}/comments",
               params: params, as: :turbo_stream
        end

        context 'when params are valid' do
          let(:params) do
            { comment: { content: 'Foobar', rating: 4, affidavit: '1' } }
          end

          describe '[HTTP status]' do
            before { action }

            it { expect(response).to have_http_status :ok }
            it { expect(flash[:notice]).to eq I18n.t('comments.create.notice', locale: locale) }
          end

          it { expect { action }.to change { Comment.count }.by(1) }
        end

        context 'when acceptance is not checked' do
          let(:params) do
            { comment: { content: 'Foobar', rating: 4 } }
          end

          describe '[HTTP status]' do
            before { action }

            it { expect(response).to have_http_status :unprocessable_content }
          end

          it { expect { action }.to_not change { Comment.count } }
        end

        context 'when acceptance is filled with random value' do
          let(:params) do
            { comment: { content: 'Foobar', rating: 4, affidavit: 'fake' } }
          end

          describe '[HTTP status]' do
            before { action }

            it { expect(response).to have_http_status :ok }
          end

          it { expect { action }.to change { Comment.count }.by(1) }
        end

        context 'when params are invalid' do
          let(:params) {  { comment: { content: '', affidavit: '1' } } }

          describe '[HTTP status]' do
            before { action }

            it { expect(response).to have_http_status :unprocessable_content }
          end

          it { expect { action }.to_not change { Comment.count } }
        end

        context 'when captcha is filled' do
          let(:params) do
            { comment: { content: 'Foobar', rating: 4, nickname: 'bot', affidavit: '1' } }
          end

          describe '[HTTP status]' do
            before { action }

            it { expect(response).to have_http_status :ok }
            it { expect(flash[:notice]).to eq I18n.t('comments.create.notice', locale: locale) }
          end

          it { expect { action }.to_not change { Comment.count } }
        end
      end
    end
  end
end
