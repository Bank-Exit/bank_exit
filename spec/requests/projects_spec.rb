require 'rails_helper'

def project_ids
  %w[grocery cheque sticker]
end

RSpec.describe 'Projects' do
  let(:invalid_project_id) { 'fake' }

  describe 'GET /projects/:id' do
    project_ids.each do |project_id|
      context "when #{project_id} project" do
        subject! { get "/projects/#{project_id}" }

        it { expect(response).to redirect_to project_en_path(project_id) }
      end
    end

    context 'when flyer project' do
      subject! { get '/projects/flyer' }

      it 'follows redirects', :aggregate_failures do
        expect(response).to redirect_to project_en_path('flyer')

        follow_redirect!

        expect(response).to redirect_to blog_en_path('flyer')
      end
    end

    context 'when project does not exist' do
      subject! { get "/projects/#{invalid_project_id}" }

      it { expect(response).to have_http_status :redirect }
    end
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/projects/:id" do
      project_ids.each do |project_id|
        context "when #{project_id} project" do
          subject! { get "/#{locale}/projects/#{project_id}" }

          it { expect(response).to have_http_status :ok }
        end
      end

      context 'when flyer project' do
        subject! { get "/#{locale}/projects/flyer" }

        it { expect(response).to redirect_to send("blog_#{locale}_path", 'flyer') }
      end

      context 'when project does not exist' do
        subject! { get "/#{locale}/projects/#{invalid_project_id}" }

        it { expect(response).to have_http_status :not_found }
      end
    end
  end
end
