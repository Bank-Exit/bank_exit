require 'rails_helper'

RSpec.describe 'Comments::Reports' do
  let(:comment) { create :comment, commentable: commentable }
  let(:invalid_comment_id) { 'fakeID' }

  context 'when commentable is merchant' do
    let(:commentable) { create :merchant }

    I18n.available_locales.each do |locale|
      describe "GET /#{locale}/merchants/:merchant_id/comments/:comment_id/report/new" do
        context 'when merchant exists' do
          subject! do
            get "/#{locale}/merchants/#{commentable.identifier}/comments/#{comment.id}/report/new",
                as: :turbo_stream
          end

          it { expect(response).to have_http_status :ok }
        end

        context 'when merchant does not exist' do
          subject! do
            get "/#{locale}/merchants/#{invalid_comment_id}/comments/#{invalid_comment_id}/report/new",
                as: :turbo_stream
          end

          it { expect(response).to have_http_status :not_found }
        end
      end

      describe "POST /#{locale}/merchants/:merchant_id/comments/:comment_id/report" do
        subject(:action) do
          post "/#{locale}/merchants/#{commentable.identifier}/comments/#{comment.id}/report",
               params: params,
               as: :turbo_stream
        end

        context 'when params are valid' do
          let(:params) do
            { comment_report: { flag_reason: :spam, description: 'Foobar' } }
          end

          it { expect { action }.to have_enqueued_mail(CommentMailer, :send_report_comment) }

          describe '[HTTP Status]' do
            before { action }

            it { expect(response).to have_http_status :ok }
            it { expect(flash[:notice]).to eq(I18n.t('comments.reports.create.notice', locale: locale)) }
          end
        end

        context 'when :description is empty' do
          let(:params) do
            { comment_report: { flag_reason: :spam, description: '' } }
          end

          it { expect { action }.to_not have_enqueued_mail(CommentMailer, :send_report_comment) }

          describe '[HTTP Status]' do
            before { action }

            it { expect(response).to have_http_status :unprocessable_content }
            it { expect(flash[:alert]).to be_nil }
          end
        end

        context 'when bot make the request' do
          let(:params) do
            { comment_report: { flag_reason: :spam, description: 'Foobar', nickname: 'bot' } }
          end

          it { expect { action }.to_not have_enqueued_mail(CommentMailer, :send_report_comment) }

          describe '[HTTP Status]' do
            before { action }

            it { expect(response).to have_http_status :ok }
            it { expect(flash[:notice]).to eq(I18n.t('comments.reports.create.notice', locale: locale)) }
          end
        end
      end
    end
  end

  context 'when commentable is directory' do
    let(:commentable) { create :directory }

    I18n.available_locales.each do |locale|
      describe "GET /#{locale}/directories/:directory_id/comments/:comment_id/report/new" do
        context 'when merchant exists' do
          subject! do
            get "/#{locale}/directories/#{commentable.id}/comments/#{comment.id}/report/new",
                as: :turbo_stream
          end

          it { expect(response).to have_http_status :ok }
        end

        context 'when merchant does not exist' do
          subject! do
            get "/#{locale}/merchants/#{invalid_comment_id}/comments/#{invalid_comment_id}/report/new",
                as: :turbo_stream
          end

          it { expect(response).to have_http_status :not_found }
        end
      end

      describe "POST /#{locale}/directories/:directory_id/comments/:comment_id/report" do
        subject(:action) do
          post "/#{locale}/directories/#{commentable.id}/comments/#{comment.id}/report",
               params: params,
               as: :turbo_stream
        end

        context 'when params are valid' do
          let(:params) do
            { comment_report: { flag_reason: :spam, description: 'Foobar' } }
          end

          it { expect { action }.to have_enqueued_mail(CommentMailer, :send_report_comment) }

          describe '[HTTP Status]' do
            before { action }

            it { expect(response).to have_http_status :ok }
            it { expect(flash[:notice]).to eq(I18n.t('comments.reports.create.notice', locale: locale)) }
          end
        end

        context 'when :description is empty' do
          let(:params) do
            { comment_report: { flag_reason: :spam, description: '' } }
          end

          it { expect { action }.to_not have_enqueued_mail(CommentMailer, :send_report_comment) }

          describe '[HTTP Status]' do
            before { action }

            it { expect(response).to have_http_status :unprocessable_content }
            it { expect(flash[:alert]).to be_nil }
          end
        end

        context 'when bot make the request' do
          let(:params) do
            { comment_report: { flag_reason: :spam, description: 'Foobar', nickname: 'bot' } }
          end

          it { expect { action }.to_not have_enqueued_mail(CommentMailer, :send_report_comment) }

          describe '[HTTP Status]' do
            before { action }

            it { expect(response).to have_http_status :ok }
            it { expect(flash[:notice]).to eq(I18n.t('comments.reports.create.notice', locale: locale)) }
          end
        end
      end
    end
  end
end
