# This class acts as a model (not related to the database)
# to interact more elegantly with local groups data.
class LocalGroup
  include ActiveModel::Model

  attr_accessor :name, :link, :countries

  def self.all
    data = YAML.load_file('db/yaml/local_groups.yml')

    data.map { |row| new(row) }
  end

  def france_count
    countries.find { it['name'] == 'France' }['regions'].count
  end
end
