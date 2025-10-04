require 'rails_helper'

RSpec.describe 'Admin::Comments' do
  describe 'GET /admin/comments' do
    subject { get '/admin/comments' }

    before do
      create_list :comment, 3
      create :comment, :flagged
    end

    %i[super_admin admin moderator].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted'
      end
    end

    %i[publisher].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access denied'
      end
    end

    context 'when logged out' do
      include_context 'without login'
      it_behaves_like 'access unauthenticated'
    end
  end

  describe 'PATCH /admin/comments/:id' do
    subject(:action) { patch "/admin/comments/#{comment.id}" }

    let(:comment) { create :comment, :flagged }

    %i[super_admin admin moderator].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_comments_path }
          let(:flash_notice) { I18n.t('admin.comments.update.notice') }
        end

        it { expect { action }.to change { comment.reload.flag_reason }.to nil }
      end
    end

    %i[publisher].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access denied'
      end
    end

    context 'when logged out' do
      include_context 'without login'
      it_behaves_like 'access unauthenticated'
    end
  end

  describe 'DELETE /admin/comments/:id' do
    subject(:action) { delete "/admin/comments/#{comment.id}" }

    let!(:comment) { create :comment, :flagged }

    %i[super_admin admin moderator].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { admin_comments_path }
          let(:flash_notice) { I18n.t('admin.comments.destroy.notice') }
        end

        it { expect { action }.to change { Comment.count }.by(-1) }
      end
    end

    %i[publisher].each do |role|
      context "when role is #{role}" do
        include_context 'with user role', role
        it_behaves_like 'access denied'
      end
    end

    context 'when logged out' do
      include_context 'without login'
      it_behaves_like 'access unauthenticated'
    end
  end
end
