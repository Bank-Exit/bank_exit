def load_schema(name, version: :v1)
  path = Rails.root.join("swagger/#{version}/schemas/#{name}.yml")
  YAML.load_file(path).deep_symbolize_keys
end
