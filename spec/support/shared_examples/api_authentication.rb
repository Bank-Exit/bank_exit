RSpec.shared_examples 'unauthorized API request' do
  run_test! do |response|
    json = parsed_response

    expect(response).to have_http_status(:unauthorized)

    expect(response.headers['WWW-Authenticate']).to eq('Bearer realm="Bank-Exit", error="invalid_token"')

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
  run_test! do |response|
    json = parsed_response

    expect(response).to have_http_status(:forbidden)

    expect(response.headers['WWW-Authenticate']).to eq('Bearer realm="Bank-Exit", error="disabled_or_expired_token"')
    expect(api_token.requests_count).to eq 0

    expect(json['errors']).to be_an(Array)
    expect(json['errors'].size).to eq(1)

    error = json['errors'].first
    expect(error).to include(
      status: '403',
      title: 'Forbidden',
      detail: I18n.t('exceptions.authenticable_errors.forbidden_token')
    )
  end
end
