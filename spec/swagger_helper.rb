require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Bank-Exit API',
        version: 'v1',
        description: <<~DESC
          Welcome to the Bank-Exit API v1 documentation.

          - This API requires Bearer token authentication.
          - All endpoints are prefixed by a locale (e.g., `/en`, `/fr`, etc.).
          - You can try out the endpoints directly from this interface.

          **Important:** To authenticate, click the 🔒 "Authorize" button and provide your token in the format: `Bearer YOUR_TOKEN_HERE`.

          For more information, please refer to the official developer documentation or contact the API support team.
        DESC
      },
      paths: {},
      components: {
        securitySchemes: {
          bearer_auth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'Token'
          }
        },
        security: [{ bearer_auth: [] }],
        schemas: {
          merchant: load_schema('merchant'),
          merchant_show_response: load_schema('merchant_show_response'),
          merchants_index_response: load_schema('merchants_index_response'),
          directory: load_schema('directory'),
          directory_show_response: load_schema('directory_show_response'),
          directories_index_response: load_schema('directories_index_response')
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
