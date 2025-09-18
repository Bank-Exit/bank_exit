require 'rails_helper'

def blog_ids
  %w[
    flyer presentation-bank-exit cbdc-digital-euro
    bank-exit-assembly-2025 qubic-vs-monero-08-2025
  ]
end

RSpec.describe 'Blogs' do
  let(:invalid_blog_id) { 'fake' }

  describe 'GET /blogs' do
    subject! { get '/blogs/' }

    it { expect(response).to have_http_status :redirect }
  end

  describe 'GET /blogs/:id' do
    blog_ids.each do |blog_id|
      context "when #{blog_id} blog" do
        subject! { get "/blogs/#{blog_id}" }

        it { expect(response).to have_http_status :redirect }
      end
    end

    context 'when blog does not exist' do
      subject! { get "/blogs/#{invalid_blog_id}" }

      it { expect(response).to have_http_status :redirect }
    end
  end

  I18n.available_locales.each do |locale|
    describe "GET /#{locale}/blogs" do
      subject! { get "/#{locale}/blogs/" }

      it { expect(response).to have_http_status :ok }
    end

    describe "GET /#{locale}/blogs/:id" do
      blog_ids.each do |blog_id|
        context "when #{blog_id} blog" do
          subject! { get "/#{locale}/blogs/#{blog_id}" }

          it { expect(response).to have_http_status :ok }
        end

        context 'when blog does not exist' do
          subject! { get "/#{locale}/blogs/#{invalid_blog_id}" }

          it { expect(response).to have_http_status :not_found }
        end
      end
    end
  end
end
