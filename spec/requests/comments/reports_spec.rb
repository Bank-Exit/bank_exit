require 'rails_helper'

RSpec.describe 'Comments::Reports' do
  let(:comment) { create :comment }
  let(:invalid_comment_id) { 'fakeID' }

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/comments/:comment_id/report/new" do
      context 'when merchant exists' do
        subject! do
          get "/#{locale}/comments/#{comment.id}/report/new",
              as: :turbo_stream
        end

        it { expect(response).to have_http_status :ok }
      end

      context 'when merchant does not exist' do
        subject! do
          get "/#{locale}/comments/#{invalid_comment_id}/report/new",
              as: :turbo_stream
        end

        it { expect(response).to have_http_status :not_found }
      end
    end

    describe "POST /#{locale}/comments/:comment_id/report" do
      subject(:action) do
        post "/#{locale}/comments/#{comment.id}/report",
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
