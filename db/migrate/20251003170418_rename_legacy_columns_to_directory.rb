class RenameLegacyColumnsToDirectory < ActiveRecord::Migration[8.0]
  def change
    rename_column :directories, :name, :name_legacy
    change_column_null :directories, :name_legacy, true, ''

    rename_column :directories, :description, :description_legacy
  end
end
