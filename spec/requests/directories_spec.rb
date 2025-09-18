require 'rails_helper'

RSpec.describe 'Directories' do
  let!(:directories) { create_list :directory, 3 }

  describe 'GET /directories' do
    subject! { get '/directories' }

    it { expect(response).to have_http_status :redirect }
  end

  describe 'GET /directories/new' do
    subject! { get '/directories/new' }

    it { expect(response).to have_http_status :redirect }
  end

  describe 'GET /directories/:id' do
    subject! { get "/directories/#{directory.id}" }

    let(:directory) { directories.first }

    it { expect(response).to have_http_status :redirect }
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/directories" do
      subject! { get "/#{locale}/directories" }

      it { expect(response).to have_http_status :ok }
    end

    describe "GET /#{locale}/directories/new" do
      subject! { get "/#{locale}/directories/new" }

      it { expect(response).to have_http_status :ok }
    end

    describe "GET /#{locale}/directories/:id" do
      subject(:action) { get "/#{locale}/directories/#{directory.id}" }

      let(:directory) { directories.first }

      before do
        stub_geocoder_from_fixture!

        create :coin_wallet, :bitcoin, walletable: directory
        create :contact_way, :twitter, contactable: directory
        create :delivery_zone, :department_75, deliverable: directory
        create :weblink, weblinkable: directory

        action
      end

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'POST /en/directories' do
    subject(:action) { post path, params: params }

    let(:method) { :post }
    let(:path) { '/en/directories' }

    before do
      stub_geocoder_from_fixture!
    end

    context 'with invalid params' do
      let(:params) do
        { directory: { category: :food } }
      end

      it { expect { action }.to_not change { Directory.count } }
      it { expect { action }.to_not have_enqueued_mail(DirectoryMailer, :send_new_directory) }

      it 'does not create a new Directory', :aggregate_failures do
        action
        expect(response).to have_http_status :unprocessable_content
      end
    end

    context 'when captcha is filled' do
      let(:params) do
        { directory: attributes_for(:directory).merge(nickname: 'iamabot') }
      end

      it { expect { action }.to_not change { Directory.count } }
      it { expect { action }.to_not have_enqueued_mail(DirectoryMailer, :send_new_directory) }

      it 'creates a new Directory', :aggregate_failures do
        action
        expect(response).to redirect_to(directories_path)
        expect(flash[:notice]).to eq(I18n.t('directories.create.notice'))
      end
    end

    context 'when user filled an invalid email' do
      let(:params) do
        { directory: attributes_for(:directory).merge(proposition_from: 'fake') }
      end

      it { expect { action }.to_not change { Directory.count } }
      it { expect { action }.to_not have_enqueued_mail(DirectoryMailer, :send_new_directory) }

      describe '[HTTP Status]' do
        before { action }

        it { expect(response).to have_http_status :unprocessable_content }
        it { expect(flash[:notice]).to be_nil }
      end
    end

    context 'with valid params' do
      let(:params) do
        {
          directory: {
            name: 'Nouveau',
            description: 'Desc',
            category: :food,
            address_attributes: { label: 'Paris' }
          }
        }
      end

      it { expect { action }.to change { Directory.count }.by(1) }
      it { expect { action }.to have_enqueued_mail(DirectoryMailer, :send_new_directory) }

      it 'creates a new Directory', :aggregate_failures do
        action
        expect(Directory.last.enabled).to be false
        expect(response).to redirect_to(directories_path)
        expect(flash[:notice]).to eq(I18n.t('directories.create.notice'))
      end
    end
  end
end
