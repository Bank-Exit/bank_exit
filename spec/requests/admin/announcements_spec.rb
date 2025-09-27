require 'rails_helper'

RSpec.describe 'Admin::Announcements' do
  let(:headers) { basic_auth_headers }

  describe 'GET /admin/announcements' do
    subject(:action) { get path, headers: headers }

    let(:method) { :get }
    let(:path) { '/admin/announcements' }

    context 'when credentials are valid' do
      before do
        create :announcement, :default
        create :announcement, :success
        create :announcement, :info
        create :announcement, :warning
        create :announcement, :error

        action
      end

      it { expect(response).to have_http_status :ok }
    end

    it_behaves_like 'an authenticated endpoint'
  end

  describe 'GET /admin/announcements/new' do
    subject(:action) { get path, headers: headers }

    let(:method) { :get }
    let(:path) { '/admin/announcements/new' }

    context 'when credentials are valid' do
      before { action }

      it { expect(response).to have_http_status :ok }
    end

    it_behaves_like 'an authenticated endpoint'
  end

  describe 'POST /admin/announcements' do
    subject(:action) { post path, params: params, headers: headers }

    let(:method) { :post }
    let(:path) { '/admin/announcements' }

    let(:params) do
      {
        announcement: {
          title: Faker::Lorem.sentence,
          description: Faker::Lorem.paragraph,
          mode: :default,
          locale: I18n.locale
        }
      }
    end

    context 'with valid params' do
      it { expect { action }.to change { Announcement.count }.by(1) }

      it 'creates a new Announcement', :aggregate_failures do
        action
        expect(response).to redirect_to(admin_announcements_path)
        expect(flash[:notice]).to eq("L'annonce a bien été créée")
      end
    end

    it_behaves_like 'an authenticated endpoint'
  end

  describe 'GET /admin/announcements/:id.turbo_stream' do
    subject(:action) { get path, headers: headers, as: :turbo_stream }

    let(:method) { :get }
    let(:path) { "/admin/announcements/#{announcement.id}" }
    let(:announcement) { create :announcement }

    context 'when credentials are valid' do
      before { action }

      it { expect(response).to have_http_status :ok }
    end

    it_behaves_like 'an authenticated endpoint'
  end

  describe 'GET /admin/announcements/:id/edit' do
    subject(:action) { get path, headers: headers }

    let(:method) { :get }
    let(:path) { "/admin/announcements/#{announcement.id}/edit" }
    let(:announcement) { create :announcement }

    context 'when credentials are valid' do
      before { action }

      it { expect(response).to have_http_status :ok }
    end

    it_behaves_like 'an authenticated endpoint'
  end

  describe 'PATCH /admin/announcements/:id' do
    subject(:action) { patch path, params: params, headers: headers }

    let(:announcement) { create :announcement }
    let(:method) { :patch }
    let(:path) { "/admin/announcements/#{announcement.id}" }

    let(:params) do
      {
        announcement: {
          title: 'Title with change'
        }
      }
    end

    context 'with valid params' do
      before { action }

      it { expect(response).to redirect_to(admin_announcements_path) }
      it { expect(flash[:notice]).to eq("L'annonce a bien été modifiée") }

      it 'updates the announcement' do
        expect(announcement.reload.title).to eq('Title with change')
      end
    end

    it_behaves_like 'an authenticated endpoint'
  end

  describe 'DELETE /admin/announcements/:id/edit' do
    subject(:action) { delete path, headers: headers }

    let(:method) { :delete }
    let(:path) { "/admin/announcements/#{announcement.id}" }
    let(:announcement) { create :announcement }

    context 'when credentials are valid' do
      before { action }

      it { expect(response).to redirect_to admin_announcements_path }
    end

    it_behaves_like 'an authenticated endpoint'
  end
end
