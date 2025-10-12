RSpec.shared_context 'with authenticated token' do
  let(:api_token) { create(:api_token, :live) }
  let(:Authorization) { "Bearer #{api_token.token}" }
end

RSpec.shared_context 'with forbidden token' do
  let(:api_token) { create(:api_token, :expired) }
  let(:Authorization) { "Bearer #{api_token.token}" }
end

RSpec.shared_context 'with missing token' do
  let(:Authorization) { nil }
end
