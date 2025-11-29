RSpec.configure do |config|
  config.before(type: :request) do
    stub_request(:get, %r{\Ahttps://api\.github\.com/repos/.+/tags\z})
      .to_return_json(
        status: 200,
        body: [
          {
            name: 'v1.1.1',
            commit: { sha: 'abcdef123456' }
          }
        ]
      )
  end
end
