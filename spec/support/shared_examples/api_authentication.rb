RSpec.shared_examples 'unauthorized API request' do
  before { subject }

  it { expect(response).to have_http_status(:unauthorized) }

  it 'returns proper WWW-Authenticate header' do
    expect(response.headers['WWW-Authenticate']).to eq('Bearer realm="Application", error="invalid_token"')
  end

  it 'returns a JSON:API compliant error', :aggregate_failures do
    json = parsed_response

    expect(json['errors']).to be_an(Array)
    expect(json['errors'].size).to eq(1)

    error = json['errors'].first
    expect(error).to include(
      status: '401',
      title: 'Unauthorized',
      detail: I18n.t('exceptions.authenticable_errors.unauthorized_token')
    )
  end
end

RSpec.shared_examples 'forbidden API request' do
  before { subject }

  it { expect(response).to have_http_status(:unauthorized) }

  it 'returns proper WWW-Authenticate header' do
    expect(response.headers['WWW-Authenticate']).to eq('Bearer realm="Application", error="invalid_token"')
  end

  it 'returns a JSON:API compliant error', :aggregate_failures do
    json = parsed_response

    expect(json['errors']).to be_an(Array)
    expect(json['errors'].size).to eq(1)

    error = json['errors'].first
    expect(error).to include(
      status: '401',
      title: 'Unauthorized',
      detail: I18n.t('exceptions.authenticable_errors.forbidden_token')
    )
  end
end
