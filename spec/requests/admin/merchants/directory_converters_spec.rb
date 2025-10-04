require 'rails_helper'

RSpec.describe 'Admin::Merchants::DirectoryConverters' do
  describe 'POST /admin/merchants/:id/directory_converters' do
    subject(:action) { post "/admin/merchants/#{merchant.to_param}/directory_converters" }

    let(:merchant) do
      create :merchant, name: 'John Doe',
                        description: 'Lorem Ipsum',
                        full_address: 'Paris',
                        coins: [:bitcoin],
                        contact_twitter: 'https://x.com/johnDoe'
    end

    before do
      stub_geocoder_from_fixture!
    end

    %i[super_admin admin publisher].each do |role|
      context "when role is #{role}" do
        let(:directory) { Directory.last }

        include_context 'with user role', role
        it_behaves_like 'access granted with redirection' do
          let(:redirection_url) { edit_admin_directory_path(directory) }
          let(:flash_notice) { "L'entrée de l'annuaire a bien été créée. Pensez à la réactiver une fois les modifications effectuées" }
          let(:flash_notice) { I18n.t('admin.merchants.directory_converters.create.notice') }
        end

        context 'when directory has already been created' do
          before do
            create :directory, merchant: merchant
          end

          it_behaves_like 'access denied'

          it { expect { action }.to_not change { Directory.count } }
        end

        context 'when directory does not yet exist' do
          before { action }

          it 'has correct regular attributes', :aggregate_failures do
            expect(directory.name).to eq 'John Doe'
            expect(directory.description).to eq 'Lorem Ipsum'
            expect(directory.category).to be_nil
            expect(directory.enabled).to be false
          end

          it { expect(directory.address.label).to eq 'Paris' }

          it 'has correct :contact_ways attributes', :aggregate_failures do
            expect(directory.contact_ways.count).to eq 1
            expect(directory.contact_ways.first.value).to eq 'https://x.com/johnDoe'
          end

          it 'has correct :coin_wallets attributes', :aggregate_failures do
            expect(directory.coin_wallets.count).to eq 1
            expect(directory.coin_wallets.first.coin).to eq 'bitcoin'
            expect(directory.coin_wallets.first.public_address).to be_nil
          end

          it { expect(directory.delivery_zones.count).to eq 0 }
        end
      end
    end

    %i[moderator].each do |role|
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
